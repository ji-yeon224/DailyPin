//
//  MainMapViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import CoreLocation


final class MainMapViewController: BaseViewController {
    
    private let mainView = MainMapView()
    private let locationManager = CLLocationManager()
    
    
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
        
    }
    
    @objc func currentButtonClicked() {
        checkDeviceLocationAuthorization()
    }
    
    
    
    
}

// 위치 서비스
extension MainMapViewController {
    func checkDeviceLocationAuthorization() {
        //위치 서비스 활성화 체크
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }else {
                self.showOKAlert(title: "", message: "locationServicesEnabled".localized()) { }
            }
        }
    }
    
    // 권한 상태 확인
    func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 사용자가 권한 설정 여부를 선택 안함
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted: // 위치 서비스 사용 권한이 없음
            showOKAlert(title: "locationAlertTitle".localized(), message: "location_Restricted".localized()) { }
        case .denied: // 사용자가 권한 요청 거부
            showRequestLocationServiceAlert()
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default: print("default")
        }
    }
    
    // 권한이 거부되었을 때 얼럿
    func showRequestLocationServiceAlert() {
        
        showAlertWithCancel(title: "locationAlertTitle".localized(), message: "locationAlertMessage".localized()) {
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
        } cancelHandler: {
            // toast
        }

    }
}

extension MainMapViewController: CLLocationManagerDelegate {
    
    
    // 사용자의 위치를 성공적으로 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            mainView.setRegionAndAnnotation(center: coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    // 사용자의 위치를 가져오지 못함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("fail")
        let center = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
        mainView.setRegionAndAnnotation(center: center)
    }
    
    // 사용자의 권한 상태가 바뀜을 체크함(iOS 14~)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}
