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
    let placeFpc = FloatingPanelController()
    let contentVC = InfoViewController()
    let placeVC = PlaceListViewController()
    weak var mapViewDelegate: MapViewProtocol?

    lazy var mapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.delegate = self
        return view
    }()
    
    let searchButton = SearchButton()
    
    let calendarButton = CalendarButton()
    let currentLocation = MyLocationButton()
    let placeListButton = PlaceListButton()
    
    
    override func configureUI() {
        addSubview(mapView)
        [searchButton, calendarButton, placeListButton, currentLocation].forEach {
            mapView.addSubview($0)
        }
        fpc.delegate = self
        placeFpc.delegate = self
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
        
        placeListButton.snp.makeConstraints { make in
            make.top.equalTo(calendarButton.snp.bottom).offset(20)
            make.trailing.equalTo(mapView).inset(15)
            make.height.equalTo(40)
            make.width.equalTo(placeListButton.snp.height).multipliedBy(1)
        }
        
        currentLocation.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(30)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-40)
            make.size.equalTo(40)
        }
        
    }
    
    
}

// map
extension MainMapView {
    func setRegion(center: CLLocationCoordinate2D, _ span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.004 )){
        
        var checkSpan = span
        if span.longitudeDelta > 0.005 && span.longitudeDelta > 0.003 {
            checkSpan = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.003)
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
    
    func deSelectedAnnotation() {
        
        if mapView.selectedAnnotations.count > 0 {
            guard let annotation = mapView.selectedAnnotations.first else { return }
            mapView.deselectAnnotation(annotation, animated: true)
        }
        
    }
    
   
    
}

extension MainMapView {
    
    func setFloatingPanel(data: PlaceElement) {
        fpc.surfaceView.insetsLayoutMarginsFromSafeArea = true
        contentVC.viewModel.place.value = data
        fpc.set(contentViewController: contentVC)
        fpc.track(scrollView: contentVC.mainView.collectionView)
        fpc.view.frame = contentVC.view.bounds
        fpc.layout = FloatingPanelCustomLayout()
        fpc.changePanelStyle()
        fpc.invalidateLayout()
    }
   
    func setPlaceFloatingPanel() {
        placeFpc.surfaceView.insetsLayoutMarginsFromSafeArea = true
        placeFpc.set(contentViewController: placeVC)
        placeFpc.view.frame = placeVC.view.bounds
        placeFpc.track(scrollView: placeVC.mainView.collectionView)
        placeFpc.layout = FloatingPanelCustomLayout()
        placeFpc.changePanelStyle()
        placeFpc.invalidateLayout()
    }
}

extension MainMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomAnnotation else {
            return
        }
        
        guard let view = view as? CustomAnnotationView else { return }
        view.imageView.tintColor = Constants.Color.subColor
        
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
                annotationView?.displayPriority = .defaultHigh
                
            }
        } else if annotation.isKind(of: CustomAnnotation.self) {
            if let annotation = annotation as? CustomAnnotation {
                annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
                //annotationView?.clusteringIdentifier = "cluster"
                annotationView?.displayPriority = .defaultLow
            }
            
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        let userView = mapView.view(for: mapView.userLocation)
        userView?.isUserInteractionEnabled = false
        userView?.isEnabled = false
        userView?.canShowCallout = false
    }
    
//    func mapView(_ mapView: MKMapView, clusterAnnotationForMemberAnnotations memberAnnotations: [MKAnnotation]) -> MKClusterAnnotation {
//        var customAnnotations: [CustomAnnotation] = []
//        for anot in memberAnnotations {
//            if let anot = anot as? CustomAnnotation {
//                customAnnotations.append(anot)
//            }
//
//        }
//
//        let cluster = MKClusterAnnotation(memberAnnotations: customAnnotations)
//        cluster.title = "+\(customAnnotations.count)"
//        cluster.subtitle = ""
//        return cluster
//    }
    
}


extension MainMapView: FloatingPanelControllerDelegate {
    
    func floatingPanelWillBeginAttracting(_ fpc: FloatingPanelController, to state: FloatingPanelState) {
        if state == FloatingPanelState.tip {
            fpc.dismiss(animated: true, completion: nil)
            deSelectedAnnotation()
            
        }
    }
    
    
}
