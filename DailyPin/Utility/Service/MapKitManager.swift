//
//  MapKitManager.swift
//  DailyPin
//
//  Created by 김지연 on 5/27/24.
//

import UIKit
import RxSwift
import CoreLocation
import MapKit

final class MapKitManager: NSObject {
    static let shared = MapKitManager()
    let setUserLocation = PublishSubject<CLLocationCoordinate2D>()
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    private let locationManager = CLLocationManager()
    weak var delegate: AuthorizationLocationProtocol?
    
    func checkDeviceLocationAuthorization() {
        //위치 서비스 활성화 체크
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if CLLocationManager.locationServicesEnabled() {
                let authorization: CLAuthorizationStatus = self.locationManager.authorizationStatus
                DispatchQueue.main.async {
                    self.checkCurrentLocationAuthorization(status: authorization)
                }
            }else {
                self.delegate?.failGetUserLoaction(title: "", message: "locationServicesEnabled".localized())
            }
        }
    }
    
    // 권한 상태 확인
    private func checkCurrentLocationAuthorization(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: // 사용자가 권한 설정 여부를 선택 안함
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters // 정확도
            locationManager.requestWhenInUseAuthorization() // 인증 요청
        case .restricted: // 위치 서비스 사용 권한이 없음
            delegate?.failGetUserLoaction(title: "locationAlertTitle".localized(), message: "location_Restricted".localized())
        case .denied: // 사용자가 권한 요청 거부
            delegate?.showRequestLocationServiceAlert()
        case .authorizedAlways: break
        case .authorizedWhenInUse:
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        @unknown default: break
        }
    }
    
    
    
    
}
extension MapKitManager: CLLocationManagerDelegate {
    // 사용자의 위치를 성공적으로 가져옴
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last?.coordinate {
            setUserLocation.onNext(coordinate)
        }
        locationManager.stopUpdatingLocation()
    }
    
    
    // 사용자의 위치를 가져오지 못함
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("fail")
//        self.mainView.setRegion(center: self.defaultLoaction)
    }
    
    // 사용자의 권한 상태가 바뀜을 체크함(iOS 14~)
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocationAuthorization()
    }
}
