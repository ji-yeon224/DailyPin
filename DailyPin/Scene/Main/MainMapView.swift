//
//  MainMapView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import MapKit
import FloatingPanel

final class MainMapView: BaseView {
    
    let fpc = FloatingPanelController()
    let contentVC = InfoViewController()
    weak var mapViewDelegate: MapViewProtocol?

    lazy var mapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.delegate = self
        return view
    }()
    let searchBarView = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 1
        return view
    }()
    
    let searchButton = SearchButton()
    
    let calendarButton = CalendarButton()
    let currentLocation = MyLocationButton()
    
    
    override func configureUI() {
        addSubview(mapView)
        mapView.addSubview(searchButton)
        mapView.addSubview(calendarButton)
        mapView.addSubview(currentLocation)
        
    }
    
    
    override func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchButton.snp.makeConstraints { make in
            make.leading.equalTo(mapView).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(50)
        }
        calendarButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(15)
            make.leading.equalTo(searchButton.snp.trailing).offset(10)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(50)
            make.width.equalTo(calendarButton.snp.height).multipliedBy(1)
        }
        
        
        
        currentLocation.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
            make.size.equalTo(40)
        }
        
    }
    
    
}

// map
extension MainMapView {
    func setRegion(center: CLLocationCoordinate2D, _ span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.004 )){
        
        var checkSpan = span
        if span.longitudeDelta > 0.05 && span.longitudeDelta > 0.03 {
            checkSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.03)
        }
        
        let region = MKCoordinateRegion(center: center, span: checkSpan)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    func setAllCustomAnnotation(annotation: [CustomAnnotation]) {
        mapView.addAnnotations(annotation)
    }
    
    func setOneAnnotation(annotation: SelectAnnotation) {
        
        setRegion(center: annotation.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    func removeOneAnnotation(annotation: SelectAnnotation) {
        mapView.removeAnnotation(annotation)
    }
    
    func removeAllCustomAnnotation(annotations: [CustomAnnotation]) {
        mapView.removeAnnotations(annotations)
    }
    
   
    
}

extension MainMapView {
    
    func setFloatingPanel(data: PlaceElement) {
        contentVC.viewModel.place.value = data
        fpc.set(contentViewController: contentVC)
        fpc.view.frame = contentVC.view.bounds
        fpc.layout = FloatingPanelCustomLayout()
        fpc.changePanelStyle()
        fpc.invalidateLayout()
    }
    
    
    
    func showMapAlert(cood: CLLocationCoordinate2D) -> UIAlertController {
        
        let alert = UIAlertController(title: nil, message: "여기가 맞습니까?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        
        //컨텐츠 뷰 영역에 들어갈 뷰 컨트롤러를 생성하고, 알림창에 등록한다.
        let contentVC = AlertMapViewController()
        contentVC.cood = cood
        //뷰 컨트롤러에 맵킷 뷰를 추가한다.
        let mapKitView = MKMapView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentVC.view = mapKitView
        contentVC.preferredContentSize.height = 200
        
        alert.setValue(contentVC, forKey: "contentViewController")
        return alert
    }
    
}

extension MainMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomAnnotation else {
            return
        }
        
        guard let view = view as? CustomAnnotationView else { return }
        view.imageView.image = Constants.Image.selectPin
        view.imageView.tintColor = Constants.Color.selectPinColor
        
        mapViewDelegate?.didSelect(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let view = view as? CustomAnnotationView else { return }
        view.imageView.image = Constants.Image.starImage
        view.imageView.tintColor = Constants.Color.pinColor
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        var annotationView: MKAnnotationView?
        
        
        if annotation.isKind(of: SelectAnnotation.self) {
            if let annotation = annotation as? SelectAnnotation {
                annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: SelectAnnotationView.identifier, for: annotation)
                
            }
        } else if annotation.isKind(of: CustomAnnotation.self) {
            if let annotation = annotation as? CustomAnnotation {
                annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
                annotationView?.clusteringIdentifier = "cluster"
            }
            
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
        var customAnnotations: [CustomAnnotation] = []
        for anot in memberAnnotations {
            if let anot = anot as? CustomAnnotation {
                customAnnotations.append(anot)
            }
            
        }
        
        let cluster = MKClusterAnnotation(memberAnnotations: customAnnotations)
        cluster.title = "+\(customAnnotations.count)"
        cluster.subtitle = ""
        return cluster
    }
    
}
