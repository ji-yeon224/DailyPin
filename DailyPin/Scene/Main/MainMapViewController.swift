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
        //locationManager.requestWhenInUseAuthorization()
        checkDeviceLocationAuthorization()
    }
    
    override func configureUI() {
        super.configureUI()
        
        
    }
    
    func checkDeviceLocationAuthorization() {
        //위치 서비스 활성화 체크
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }else {
                self.showOKAlert(title: "", message: "위치 서비스가 꺼져있습니다.") { }
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
            print("restricted")
        case .denied: // 사용자가 권한 요청 거부
            showRequestLocationServiceAlert()
            print("denied")
        case .authorizedAlways:
            print("authorizedAlways")
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default: print("default")
        }
    }
    
    // 권한이 거부되었을 때 얼럿
    func showRequestLocationServiceAlert() {
        
        showAlertWithCancel(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.") {
            // 설정 이동
        } cancelHandler: {
            // toast
        }

    }
    
    
}

extension MainMapViewController: CLLocationManagerDelegate {
    
    
    // 사용자의 위치를 성공적으로 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    
    // 사용자의 위치를 가져오지 못함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
    
    // 사용자의 권한 상태가 바뀜을 체크함(iOS 14~)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
    
}
