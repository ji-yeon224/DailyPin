//
//  MainMapViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit

final class MainMapViewController: BaseViewController {
    
    private let mainView = MainMapView()
    private let viewModel = MainMapViewModel()
    private let placeRepository = PlaceRepository()
    
    private let locationManager = CLLocationManager()
    private let defaultLoaction = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
    
    private var infoViewOn: Bool = false
    private let repository = PlaceRepository()
    private var allData: [Place]?
    
    private var searchAnnotation: SelectAnnotation?
    private var annotations: [CustomAnnotation] = []
    
    override func loadView() {
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self 
        checkDeviceLocationAuthorization()
        mainView.mapViewDelegate = self
        
        mainView.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mainView.mapView.register(SelectAnnotationView.self, forAnnotationViewWithReuseIdentifier: SelectAnnotationView.identifier)
        
        notificationObserver()
        
        viewModel.getAllPlaceAnnotation()
        bindData()
        
        
    }
    
    private func notificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.databaseChange, object: nil)
        //NotificationCenter.default.addObserver(self, selector: #selector(getNetworkNotification), name: Notification.Name.networkConnect, object: nil)
    }
    
    private func bindData() {
        
        viewModel.annotations.bind { data in
            self.mainView.setAllCustomAnnotation(annotation: data)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
        setButtonAction()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped))
        mainView.mapView.addGestureRecognizer(tapGesture)
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressMap(_ :)))
        longPressGesture.minimumPressDuration = 1
        longPressGesture.delaysTouchesBegan = true
        
        mainView.mapView.addGestureRecognizer(longPressGesture)
        
    }
    
    
    @objc private func getNetworkNotification() {
        DispatchQueue.main.async {
            self.showOKAlert(title: "network_connectErrorTitle".localized(), message: "network_connectError".localized()) {
                
            }
        }
        
    }
    
    @objc private func longPressMap(_ sender: UILongPressGestureRecognizer) {
        let location: CGPoint = sender.location(in: self.mainView.mapView)
        let mapPoint: CLLocationCoordinate2D = self.mainView.mapView.convert(location, toCoordinateFrom: self.mainView.mapView)
        
        if sender.state == .ended {
            if !NetworkMonitor.shared.isConnected {
                self.getNetworkNotification()
                return
            }
            self.viewModel.requestSelectedLocation(lat: mapPoint.latitude, lng: mapPoint.longitude) { address in
                
                self.showAlertMap(address: address, cood: mapPoint) {
                    self.presentRecordView()
                } cancelHandler: {
                    return
                }
                
                
            } failCompletion: { error in
                self.showToastMessage(message: error.errorDescription ?? "toast_errorAlert".localized())
            }
            
            
        }
        
    }
    
    func presentRecordView() {
        let vc = RecordViewController()
        vc.location = self.viewModel.selectedLocation
        vc.record = nil
        vc.editMode = true
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true)
    }
    
    private func setButtonAction() {
        mainView.currentLocation.addTarget(self, action: #selector(currentButtonClicked), for: .touchUpInside)
        mainView.searchButton.addTarget(self, action: #selector(searchViewTransition), for: .touchUpInside)
        mainView.calendarButton.addTarget(self, action: #selector(calendarButtonTapped), for: .touchUpInside)
    }
    
    @objc private func getChangeNotification(notification: NSNotification) {
        
        
        guard let notiInfo = notification.userInfo else { return }
        
        if let type = notiInfo["changeType"] as? String {
            if type == "save" {
                deleteSearchAnnotation()
            } else {
                if infoViewOn {
                    mainView.fpc.dismiss(animated: true)
                    infoViewOn.toggle()
                }
                deleteSearchAnnotation()
            }
        }
        mainView.removeAllCustomAnnotation(annotations: viewModel.annotations.value)
        viewModel.getAllPlaceAnnotation()
    }
    

    
    
    
    @objc private func calendarButtonTapped() {
        
        if infoViewOn {
            mainView.fpc.dismiss(animated: true)
            infoViewOn.toggle()
        }
        
        let vc = CalendarViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
    }
    
    @objc private func mapViewTapped() {
        
        if infoViewOn {
            mainView.fpc.dismiss(animated: true)
            infoViewOn.toggle()
        }
        
        deleteSearchAnnotation()
       
        
    }
    
    
    @objc private func searchViewTransition() {
        let vc = SearchViewController()
        if infoViewOn == true {
            infoViewOn = false
            self.mainView.fpc.dismiss(animated: true)
        }
        
        if !mainView.mapView.selectedAnnotations.isEmpty {
            mainView.mapView.deselectAnnotation(mainView.mapView.selectedAnnotations.first, animated: true)
        }
        
        deleteSearchAnnotation()
        
        vc.selectLocationHandler = { value in
            let center = CLLocationCoordinate2D(latitude: value.location.latitude, longitude: value.location.longitude)
            
            
            self.searchAnnotation = SelectAnnotation(placeID: value.id, coordinate: center)
            if let searchAnnotation = self.searchAnnotation {
                self.mainView.setOneAnnotation(annotation: searchAnnotation)
            }
            
            DispatchQueue.main.async {
                self.mainView.setFloatingPanel(data: value)
                self.present(self.mainView.fpc, animated: true)
                self.infoViewOn = true
            }
            
        }
        vc.centerLocation = (mainView.mapView.centerCoordinate.latitude, mainView.mapView.centerCoordinate.longitude)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
        
        
    }
    
    
    @objc private func currentButtonClicked() {
        checkDeviceLocationAuthorization()
    }
    
    // 검색 결과로 찍힌 핀 지우기
    private func deleteSearchAnnotation() {
        if let searchAnnotation = searchAnnotation {
            mainView.removeOneAnnotation(annotation: searchAnnotation)
            self.searchAnnotation = nil
        }
        
    }
    
    // alert 지도
    private func showAlertMap(address: String, cood: CLLocationCoordinate2D, okHandler: (() -> Void)?, cancelHandler: (() -> Void)?) {
        let alert = UIAlertController(title: "alert_addRecordTitle".localized(), message: address, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "okText".localized(), style: .default) { _ in
            okHandler?()
        }
        let cancel = UIAlertAction(title: "cancelText".localized(), style: .destructive) { _ in
            cancelHandler?()
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        let contentVC = AlertMapViewController()
        contentVC.cood = cood
        
        alert.setValue(contentVC, forKey: "contentViewController")
        
        present(alert, animated: true)
    }
    
    
}

extension MainMapViewController: MapViewProtocol {
    func didSelect(annotation: CustomAnnotation) {
        if infoViewOn {
            mainView.fpc.dismiss(animated: true)
            infoViewOn.toggle()
        }
        
        // InfoView Present
        guard let place = viewModel.getPlaceData(id: annotation.placeID) else {
            return
        }
        
        
        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mainView.setRegion(center: coord, mainView.mapView.region.span)
        mainView.setFloatingPanel(data: viewModel.convertPlaceToPlaceElement(place: place))
        present(self.mainView.fpc, animated: true)
        infoViewOn = true
        
    }
    
    
    
}

// 위치 서비스
extension MainMapViewController {
    private func checkDeviceLocationAuthorization() {
        //위치 서비스 활성화 체크
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }else {
                self.showOKAlert(title: "", message: "locationServicesEnabled".localized()) {
                    self.mainView.setRegion(center: self.defaultLoaction)
                }
            }
        }
    }
    
    // 권한 상태 확인
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 사용자가 권한 설정 여부를 선택 안함
            locationManager.desiredAccuracy = kCLLocationAccuracyBest // 정확도
            locationManager.requestWhenInUseAuthorization() // 인증 요청
        case .restricted: // 위치 서비스 사용 권한이 없음
            showOKAlert(title: "locationAlertTitle".localized(), message: "location_Restricted".localized()) {
                self.mainView.setRegion(center: self.defaultLoaction)
            }
        case .denied: // 사용자가 권한 요청 거부
            showRequestLocationServiceAlert()
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default: break
        }
    }
    
    // 권한이 거부되었을 때 얼럿
    private func showRequestLocationServiceAlert() {
        
        showAlertWithCancel(title: "locationAlertTitle".localized(), message: "location_denied".localized()) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        } cancelHandler: {
            // toast
        }
        
        self.mainView.setRegion(center: self.defaultLoaction)
    }
}

extension MainMapViewController: CLLocationManagerDelegate {
    
    
    // 사용자의 위치를 성공적으로 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mainView.setRegion(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    // 사용자의 위치를 가져오지 못함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
        self.mainView.setRegion(center: self.defaultLoaction)
    }
    
    // 사용자의 권한 상태가 바뀜을 체크함(iOS 14~)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}
