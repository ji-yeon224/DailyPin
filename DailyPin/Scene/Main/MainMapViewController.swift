//
//  MainMapViewController.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import CoreLocation
import MapKit
import RealmSwift

final class MainMapViewController: BaseViewController {
    
    private let mainView = MainMapView()
    //private let viewModel = MainMapViewModel()
    private let placeRepository = PlaceRepository()
    
    private let locationManager = CLLocationManager()
    private let defaultLoaction = CLLocationCoordinate2D(latitude: 37.566713, longitude: 126.978428)
    
    private var infoViewOn: Bool = false
    private let repository = PlaceRepository()
    private var allData: Results<Place>?
    
    private var searchAnnotation = MKPointAnnotation()
    private var annotations: [CustomAnnotation] = [] {
        didSet {
            mainView.setAllCustomAnnotation(annotation: annotations)
        }
    }
    
    override func loadView() {
        self.view = mainView
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        checkDeviceLocationAuthorization()
        mainView.mapView.delegate = self
        mainView.mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: CustomAnnotationView.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        allData = repository.fetch()
        setAllAnotation()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        allData = repository.fetch()
//        setAllAnotation()
//    }
    
    private func setAllAnotation() {
        
        guard let allData = allData else {
            return
        }
        
        for data in allData {
            let coord = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            let customAnnotation = CustomAnnotation(placeID: data.placeId, coordinate: coord)
            annotations.append(customAnnotation)
        }
        
    }
    
    
    
    
    override func configureUI() {
        super.configureUI()
        mainView.currentLocation.addTarget(self, action: #selector(currentButtonClicked), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(mapViewTapped(_ :)))
        mainView.mapView.addGestureRecognizer(tapGesture)
        mainView.searchButton.addTarget(self, action: #selector(searchViewTransition), for: .touchUpInside)
    }
    
    @objc private func mapViewTapped(_ sender: UITapGestureRecognizer) {
        
        if infoViewOn {
            mainView.fpc.dismiss(animated: true)
            infoViewOn.toggle()
        }
        // 검색 결과로 찍힌 핀 지우기
        mainView.removeOneAnnotation(annotation: searchAnnotation)
        
    }
    
    @objc private func searchViewTransition() {
        let vc = SearchViewController()
        if infoViewOn == true {
            infoViewOn = false
            self.mainView.fpc.dismiss(animated: true)
        }
        
        vc.selectLocationHandler = { value in
            let center = CLLocationCoordinate2D(latitude: value.location.latitude, longitude: value.location.longitude)
            
            self.searchAnnotation = MKPointAnnotation()
            self.searchAnnotation.coordinate = center
            self.searchAnnotation.title = value.displayName.placeName
            
            self.mainView.setSearchAnnotation(annotation: self.searchAnnotation)
            
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

extension MainMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(#function)
        guard let annotation = view.annotation as? CustomAnnotation else {
            return
        }
        
        guard let view = view as? CustomAnnotationView else { return }
        view.imageView.image = Image.ImageName.selectPin
        view.imageView.tintColor = Constants.Color.selectPinColor
       
        if infoViewOn {
            mainView.fpc.dismiss(animated: true)
            infoViewOn.toggle()
        }
        
        // InfoView Present
        guard let place = getPlaceData(id: annotation.placeID) else {
            showToastMessage(message: "데이터를 가져오는데 문제가 발생하였습니다.")
            return
        }
        let coord = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        mainView.setRegion(center: coord)
        mainView.setFloatingPanel(data: convertPlaceToPlaceElement(place: place))
        present(self.mainView.fpc, animated: true)
        infoViewOn = true
        
        
    }
    
    private func convertPlaceToPlaceElement(place: Place) -> PlaceElement {
        return PlaceElement(id: place.placeId, formattedAddress: place.address, location: Location(latitude: place.latitude, longitude: place.longitude), displayName: DisplayName(placeName: place.placeName))
    }
    
    private func getPlaceData(id: String) -> Place? {
        
        do {
            let place = try placeRepository.searchItemByID(id)
            return place
        } catch {
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        print("didDeselect")
        guard let view = view as? CustomAnnotationView else { return }
        view.imageView.image = Image.ImageName.starImage
        view.imageView.tintColor = Constants.Color.pinColor
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        if let annotation = annotation as? CustomAnnotation {
            annotationView = mainView.mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
            
        }
                
        return annotationView
    }
    
}
