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
    private let locationManager = CLLocationManager()
    private let defaultLoaction = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
    
    private var infoViewOn: Bool = false
    
    override func loadView() {
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
    }
    
    
    
    
    override func configureUI() {
        super.configureUI()
        mainView.currentLocation.addTarget(self, action: #selector(currentButtonClicked), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(_ :)))
        mainView.mapView.addGestureRecognizer(tapGesture)
//        mainView.searchBar.searchTextField.addTarget(self, action: #selector(searchViewTransition), for: .editingDidBegin)
        mainView.searchButton.addTarget(self, action: #selector(searchViewTransition), for: .touchUpInside)
    }
    
    @objc private func searchViewTransition() {
        let vc = SearchViewController()
        print(infoViewOn)
        if infoViewOn == true {
            self.mainView.fpc.dismiss(animated: true)
        }
        
        vc.selectLocationHandler = { value in
            let center = CLLocationCoordinate2D(latitude: value.location.latitude, longitude: value.location.longitude)
            self.mainView.searchResultAnnotation(center: center, title: value.displayName.text)
            DispatchQueue.main.async {
                self.mainView.setFloatingPanel(data: value)
                self.present(self.mainView.fpc, animated: true)
                self.infoViewOn = true
            }
            
        }
        
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(nav, animated: true)
        
        
    }
    
    
    @objc private func currentButtonClicked() {
        checkDeviceLocationAuthorization()
    }
    
    @objc private func mapViewTapped(_ sender: UITapGestureRecognizer) {
        let location: CGPoint = sender.location(in: mainView.mapView)
        let mapPoint: CLLocationCoordinate2D = mainView.mapView.convert(location, toCoordinateFrom: mainView.mapView)
        
        mainView.setAnnotation(center: mapPoint)
        
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
        @unknown default: print("default")
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
