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
    
    private let searchView = UIImageView().then {
        $0.image = Constants.Image.searchButtonBg
        $0.backgroundColor = .clear
        $0.isUserInteractionEnabled = true
    }
    let searchTextButton = UIButton().then {
        $0.setTitle("searchPlaceholder".localized(), for: .normal)
        $0.setTitleColor(Constants.Color.placeholderColor, for: .normal)
        $0.contentHorizontalAlignment = .leading
        $0.titleLabel?.font = Font.body.fontStyle
    }
    
    
    let calendarButton = CustomImageButton(img: Constants.Image.calendarButton)
    let currentLocation = CustomImageButton(img: Constants.Image.curLocation)
    let placeListButton = CustomImageButton(img: Constants.Image.placeListButton)
    
    
    override func configureUI() {
        addSubview(mapView)
        searchView.addSubview(searchTextButton)
        [searchView, calendarButton, placeListButton, currentLocation].forEach {
            mapView.addSubview($0)
        }
    }
    
    
    override func setConstraints() {
        
        
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        searchView.snp.makeConstraints { make in
            make.leading.equalTo(mapView).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(50)
        }
        searchTextButton.snp.makeConstraints { make in
            make.leading.equalTo(searchView).inset(15)
            make.verticalEdges.equalTo(searchView)
            make.trailing.equalTo(searchView).inset(20)
        }
        calendarButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(15)
            make.leading.equalTo(searchView.snp.trailing).offset(10)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.size.equalTo(50)
        }
        
        placeListButton.snp.makeConstraints { make in
            make.top.equalTo(calendarButton.snp.bottom).offset(15)
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
    
    func setOneAnnotation(annotation: CustomAnnotation) {
        
        setRegion(center: annotation.coordinate)
        mapView.addAnnotation(annotation)
    }
    
    
    func removeOneAnnotation(annotation: CustomAnnotation) {
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
        view.changePin(state: .select)
        mapViewDelegate?.didSelect(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        guard let view = view as? CustomAnnotationView else { return }
        view.changePin(state: .nomal)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
        if let customAnnotation = annotation as? CustomAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: CustomAnnotationView.identifier) as? CustomAnnotationView
            
            if annotationView == nil {
                annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: CustomAnnotationView.identifier)
            } else {
                annotationView?.annotation = customAnnotation
            }
            
            if customAnnotation.isHighlight {
                annotationView?.changePin(state: .highlight)
            } else {
                annotationView?.changePin(state: .nomal)
            }
            
            annotationView?.displayPriority = .required
            return annotationView
        }
        
        return nil
        
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


