//
//  MainMapView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import MapKit

final class MainMapView: BaseView {
    
    weak var mapViewDelegate: MapViewProtocol?

    lazy var mapView = {
        let view = MKMapView()
        view.showsCompass = false
        view.delegate = self
        return view
    }()
    
    let searchButton = SearchButton()
    
    let calendarButton = CustomImageButton(img: Constants.Image.calendarButton)
    let currentLocation = CustomImageButton(img: Constants.Image.curLocation)
    let placeListButton = CustomImageButton(img: Constants.Image.placeListButton)
    
    
    override func configureUI() {
        addSubview(mapView)
        [searchButton, calendarButton, placeListButton, currentLocation].forEach {
            mapView.addSubview($0)
        }
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
            make.size.equalTo(50)
        }
        
        placeListButton.snp.makeConstraints { make in
            make.top.equalTo(calendarButton.snp.bottom).offset(20)
            make.trailing.equalTo(mapView).inset(15)
            make.size.equalTo(40)
        }
        
        currentLocation.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(15)
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-30)
            make.size.equalTo(44)
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
        
        let selectedAnnotations = mapView.selectedAnnotations
        for annotation in selectedAnnotations {
            mapView.deselectAnnotation(annotation, animated: false)
        }
        
        
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
                annotationView?.displayPriority = .required
                
            }
        } else if annotation.isKind(of: CustomAnnotation.self) {
            if let annotation = annotation as? CustomAnnotation {
                annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier, for: annotation)
                //annotationView?.clusteringIdentifier = "cluster"
                annotationView?.displayPriority = .required
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


