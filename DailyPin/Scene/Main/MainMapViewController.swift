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
    private let writeLongPress = PublishSubject<(Double, Double)>()
    
    override func loadView() {
        self.view = mainView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mapViewDelegate = self
        notificationObserver()
        
        BottomSheetManager.shared.delegate = self
        MapKitManager.shared.checkDeviceLocationAuthorization()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        
    }
    
    override func configureUI() {
        super.configureUI()
        bindData()
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
        
        viewModel.allAnnotations
            .bind(with: self) { owner, annotations in
                owner.mainView.setAllCustomAnnotation(annotation: annotations)
            }
        
            .disposed(by: disposeBag)
        
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
        
        viewModel.geoInfo
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, item in
                owner.showAlertMap(placeInfo: item)
            }
            .disposed(by: disposeBag)
        writeLongPress
            .bind(with: self) { owner, coord in
                let vc = RecordWriteViewController(mode: .create, record: nil, location: owner.viewModel.selectedLocation)
                vc.longPressHandler = {
                    owner.mainView.setRegion(center: CLLocationCoordinate2D(latitude: coord.0, longitude: coord.1))
                    BottomSheetManager.shared.setFloatingView(viewType: .info(data: owner.viewModel.selectedLocation), vc: owner)
                }
                owner.transitionNav(vc: vc)
            }
            .disposed(by: disposeBag)
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
        
        mainView.searchTextButton.rx.tap
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
        mainView.removeAllCustomAnnotation(annotations: viewModel.allAnnotationList)
        viewModel.getAllPlaceAnnotation()
    }
    
    private func longPressMap(_ sender: UILongPressGestureRecognizer) {
        let location: CGPoint = sender.location(in: self.mainView.mapView)
        let mapPoint: CLLocationCoordinate2D = self.mainView.mapView.convert(location, toCoordinateFrom: self.mainView.mapView)
        
        BottomSheetManager.shared.dismiss()
        viewModel.requestGeocoding(lat: mapPoint.latitude, lng: mapPoint.longitude)
        
    }
    
    
    private func searchViewTransition() {
        
        
        BottomSheetManager.shared.dismiss()
        
        if !mainView.mapView.selectedAnnotations.isEmpty {
            mainView.mapView.deselectAnnotation(mainView.mapView.selectedAnnotations.first, animated: true)
        }
        
        deleteSearchAnnotation()
        let vc = SearchViewController(location: (mainView.mapView.centerCoordinate.latitude, mainView.mapView.centerCoordinate.longitude))
        vc.delegate = self
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
    private func showAlertMap(placeInfo: PlaceItem) {
        
        guard let lat = placeInfo.latitude, let lng = placeInfo.longitude else { return }
        
        let alert = UIAlertController(title: "alert_addRecordTitle".localized(), message: placeInfo.address, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "okText".localized(), style: .default) { _ in
            self.writeLongPress.onNext((lat, lng))
        }
        let cancel = UIAlertAction(title: "cancelText".localized(), style: .destructive) { _ in
            
        }
        alert.addAction(cancel)
        alert.addAction(ok)
        
        let contentVC = AlertMapViewController(lat: lat, lng: lng)
        
        
        alert.setValue(contentVC, forKey: "contentViewController")
        
        present(alert, animated: true)
    }
}

extension MainMapViewController: SearchResultProtocol {
    func selectSearchResult(place: PlaceItem) {
        guard let lat = place.latitude, let lng = place.longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        
        searchAnnotation = SelectAnnotation(placeID: place.id, coordinate: center)
        if let searchAnnotation = searchAnnotation {
            mainView.setOneAnnotation(annotation: searchAnnotation)
        }
        
        DispatchQueue.main.async {
            BottomSheetManager.shared.setFloatingView(viewType: .info(data: place), vc: self)
        }
    }
    
    
}


extension MainMapViewController: MapViewProtocol {
    func didSelect(annotation: CustomAnnotation) {
        // InfoView Present
        guard let place = viewModel.getPlaceData(id: annotation.placeID), let lat = place.latitude, let lng = place.longitude else {
            return
        }
        let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        mainView.setRegion(center: coord, mainView.mapView.region.span)
        BottomSheetManager.shared.setFloatingView(viewType: .info(data: place), vc: self)
        
    }
    
}

extension MainMapViewController: BottomSheetProtocol {
    func setLocation(data: PlaceItem) {
        guard let lat = data.latitude, let lng = data.longitude else { return }
        let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        searchAnnotation = SelectAnnotation(placeID: data.id, coordinate: center)
        if let searchAnnotation = self.searchAnnotation {
            self.mainView.setOneAnnotation(annotation: searchAnnotation)
        }
        
        BottomSheetManager.shared.setFloatingView(viewType: .info(data: data), vc: self)
        
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
    
    func failGetUserLoaction(message: String) {
        toastMessage.accept(message)
        mainView.setRegion(center: self.defaultLoaction)
    }
    
    
}
