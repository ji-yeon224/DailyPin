//
//  MainMapViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import CoreLocation

import RxSwift
import RxCocoa
import RxGesture

final class MainMapViewController: BaseViewController {
    
    private let mainView = MainMapView()
    private let viewModel = MainMapViewModel()
    
    private let defaultLoaction = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
    private var searchAnnotation: SelectAnnotation?
    
    private var disposeBag = DisposeBag()
    private let toastMessage = PublishRelay<String>()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mapViewDelegate = self
        notificationObserver()
        bindData()
        BottomSheetManager.shared.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        MapKitManager.shared.checkDeviceLocationAuthorization()
    }
    
    override func configureUI() {
        super.configureUI()
        bindUI()
        configMapView()
        
    }
    
    private func notificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getChangeNotification), name: .databaseChange, object: nil)
    }
    
    private func configMapView() {
        
        MapKitManager.shared.delegate = self
        mainView.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
        mainView.mapView.register(SelectAnnotationView.self, forAnnotationViewWithReuseIdentifier: SelectAnnotationView.identifier)
        viewModel.getAllPlaceAnnotation()
        
    }
    
    private func bindData() {
        
        viewModel.annotations.bind { data in
            self.mainView.setAllCustomAnnotation(annotation: data)
        }
        MapKitManager.shared.setUserLocation
            .bind(with: self) { owner, coordinate in
                owner.mainView.setRegion(center: coordinate)
            }
            .disposed(by: disposeBag)
        
        toastMessage
            .asDriver(onErrorJustReturn: "")
            .drive(with: self) { owner, value in
                owner.showToastMessage(message: value)
            }
            .disposed(by: disposeBag)
        NetworkMonitor.shared.connected
            .bind(with: self) { owner, isConnected in
                if !isConnected {
                    owner.showOKAlert(title: "network_connectErrorTitle".localized(), message: "network_connectError".localized()) {}
                }
            }
            .disposed(by: DisposeBag())
        
    }
    
    private func bindUI() {
        
        mainView.currentLocation.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                MapKitManager.shared.checkDeviceLocationAuthorization()
            }
            .disposed(by: disposeBag)
        
        mainView.calendarButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                BottomSheetManager.shared.dismiss()
                owner.deleteSearchAnnotation()
                owner.mainView.deSelectedAnnotation()
                owner.transitionPushNav(vc: CalendarViewController())
            }
            .disposed(by: disposeBag)
        mainView.placeListButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.deleteSearchAnnotation()
                owner.mainView.deSelectedAnnotation()
                
                BottomSheetManager.shared.setFloatingView(viewType: .place, vc: owner)
            }
            .disposed(by: disposeBag)
        
        mainView.searchButton.rx.tap
            .asDriver()
            .drive(with: self) { owner, _ in
                owner.searchViewTransition()
            }
            .disposed(by: disposeBag)
        
        mainView.mapView.rx.tapGesture()
            .subscribe(with: self) { owner, _ in
                BottomSheetManager.shared.dismiss()
                owner.deleteSearchAnnotation()
                owner.mainView.deSelectedAnnotation()
            }
            .disposed(by: disposeBag)
        mainView.mapView.rx.longPressGesture()
            .when(.began)
            .subscribe(with: self) { owner, gesture in
                owner.longPressMap(gesture)
            }
            .disposed(by: disposeBag)
    }
    
    private func transitionPushNav(vc: UIViewController?) {
        guard let vc = vc else { return }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func transitionNav(vc: UIViewController?) {
        guard let vc = vc else { return }
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        nav.modalTransitionStyle = .crossDissolve
        self.present(nav, animated: true)
    }
    
}

extension MainMapViewController {
    
    @objc private func getNetworkNotification() {
        DispatchQueue.main.async {
            self.showOKAlert(title: "network_connectErrorTitle".localized(), message: "network_connectError".localized()) {}
        }
    }
    
    
    @objc private func getChangeNotification(notification: NSNotification) {
        guard let notiInfo = notification.userInfo else { return }
        
        if let type = notiInfo["changeType"] as? String {
            if type == "save" {
                deleteSearchAnnotation()
            } else {
                BottomSheetManager.shared.dismiss()
                deleteSearchAnnotation()
            }
        }
        mainView.removeAllCustomAnnotation(annotations: viewModel.annotations.value)
        viewModel.getAllPlaceAnnotation()
    }
    
    private func longPressMap(_ sender: UILongPressGestureRecognizer) {
        let location: CGPoint = sender.location(in: self.mainView.mapView)
        let mapPoint: CLLocationCoordinate2D = self.mainView.mapView.convert(location, toCoordinateFrom: self.mainView.mapView)
        
        BottomSheetManager.shared.dismiss()
        
//        if !NetworkMonitor.shared.isConnected {
//            self.getNetworkNotification()
//            return
//        }
        self.viewModel.requestSelectedLocation(lat: mapPoint.latitude, lng: mapPoint.longitude) { [weak self] place in
            
            guard let self = self else { return }
            
            self.showAlertMap(address: place.formattedAddress, cood: mapPoint) {
                
                let vc = RecordWriteViewController(mode: .create, record: nil, location: self.viewModel.selectedLocation)
                vc.longPressHandler = {
                    DispatchQueue.main.async {
                        self.mainView.setRegion(center: mapPoint, self.mainView.mapView.region.span)
                        BottomSheetManager.shared.setFloatingView(viewType: .info(data: place), vc: self)
                    }
                }
                self.transitionNav(vc: vc)
                
            } cancelHandler: {
                return
            }
            
            
        } failCompletion: { error in
            self.toastMessage.accept(error.errorDescription ?? "toast_errorAlert".localized())
        }
    }
    
    
    private func searchViewTransition() {
        let vc = SearchViewController()
        
        BottomSheetManager.shared.dismiss()
        
        if !mainView.mapView.selectedAnnotations.isEmpty {
            mainView.mapView.deselectAnnotation(mainView.mapView.selectedAnnotations.first, animated: true)
        }
        
        deleteSearchAnnotation()
        
        vc.selectLocationHandler = { [weak self] value in
            
            guard let self = self else { return }
            
            let center = CLLocationCoordinate2D(latitude: value.location.latitude, longitude: value.location.longitude)
            
            
            self.searchAnnotation = SelectAnnotation(placeID: value.id, coordinate: center)
            if let searchAnnotation = self.searchAnnotation {
                self.mainView.setOneAnnotation(annotation: searchAnnotation)
            }
            
            
            DispatchQueue.main.async {
                BottomSheetManager.shared.setFloatingView(viewType: .info(data: value), vc: self)
            }
            
        }
        vc.centerLocation = (mainView.mapView.centerCoordinate.latitude, mainView.mapView.centerCoordinate.longitude)
        transitionNav(vc: vc)
        
        
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
        // InfoView Present
        guard let place = viewModel.getPlaceData(id: annotation.placeID) else {
            return
        }
        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mainView.setRegion(center: coord, mainView.mapView.region.span)
        BottomSheetManager.shared.setFloatingView(viewType: .info(data: viewModel.convertPlaceToPlaceElement(place: place)), vc: self)
        
    }
    
}

extension MainMapViewController: BottomSheetProtocol {
    func setLocation(data: Place) {
        let center = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        searchAnnotation = SelectAnnotation(placeID: data.placeId, coordinate: center)
        if let searchAnnotation = self.searchAnnotation {
            self.mainView.setOneAnnotation(annotation: searchAnnotation)
        }
        
        BottomSheetManager.shared.setFloatingView(viewType: .info(data: viewModel.convertPlaceToPlaceElement(place: data)), vc: self)
        
    }
    
    func deSelectAnnotation() {
        mainView.deSelectedAnnotation()
    }
    
}

extension MainMapViewController: AuthorizationLocationProtocol {
    // 권한이 거부되었을 때 얼럿
    func showRequestLocationServiceAlert() {
        
        showAlertWithCancel(title: "locationAlertTitle".localized(), message: "location_denied".localized()) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        } cancelHandler: {
            self.showOKAlert(title: "", message: "location_Restricted".localized()) { }
        }
        
        self.mainView.setRegion(center: self.defaultLoaction)
    }
    
    func failGetUserLoaction(title: String, message: String) {
        showOKAlert(title: title, message: message) {
            self.mainView.setRegion(center: self.defaultLoaction)
        }
    }
    
    
}
