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
        
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: Notification.Name.databaseChange, object: nil)
        
        viewModel.getAllPlaceAnnotation()
        bindData()
    }
    
    private func bindData() {
        
        viewModel.annotations.bind { data in
            self.mainView.setAllCustomAnnotation(annotation: data)
        }
        
    }
    
    override func configureUI() {
        super.configureUI()
        mainView.currentLocation.addTarget(self, action: #selector(currentButtonClicked), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(_ :)))
        mainView.mapView.addGestureRecognizer(tapGesture)
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
    
    @objc private func mapViewTapped(_ sender: UITapGestureRecognizer) {
        
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
        mainView.setRegion(center: coord)
        mainView.setFloatingPanel(data: viewModel.convertPlaceToPlaceElement(place: place))
        present(self.mainView.fpc, animated: true)
        infoViewOn = true
        
    }
    
    
    
}

//
//extension MainMapViewController: MKMapViewDelegate {
//
//    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//
//
//
//        guard let annotation = view.annotation as? CustomAnnotation else {
//            return
//        }
//
//        guard let view = view as? CustomAnnotationView else { return }
//        view.imageView.image = Constants.Image.selectPin
//        view.imageView.tintColor = Constants.Color.selectPinColor
//
//        if infoViewOn {
//            mainView.fpc.dismiss(animated: true)
//            infoViewOn.toggle()
//        }
//
//        // InfoView Present
//        guard let place = viewModel.getPlaceData(id: annotation.placeID) else {
//            return
//        }
//        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
//        mainView.setRegion(center: coord)
//        mainView.setFloatingPanel(data: viewModel.convertPlaceToPlaceElement(place: place))
//        present(self.mainView.fpc, animated: true)
//        infoViewOn = true
//
//
//    }
//
//
//    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//
//        guard let view = view as? CustomAnnotationView else { return }
//        view.imageView.image = Constants.Image.starImage
//        view.imageView.tintColor = Constants.Color.pinColor
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
//
//        var annotationView: MKAnnotationView?
//
//
//        if annotation.isKind(of: SelectAnnotation.self) {
//            if let annotation = annotation as? SelectAnnotation {
//                annotationView = mainView.mapView.dequeueReusableAnnotationView(withIdentifier: SelectAnnotationView.identifier, for: annotation)
//
//            }
//        } else if annotation.isKind(of: CustomAnnotation.self) {
//            if let annotation = annotation as? CustomAnnotation {
//                annotationView = mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
//
//            }
//        }
//
//
//
//        return annotationView
//    }
//
//}
//
//

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
