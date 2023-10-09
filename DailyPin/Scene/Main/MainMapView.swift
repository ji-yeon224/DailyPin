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

    let mapView = {
        let view = MKMapView()
        view.showsCompass = false
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
            make.trailing.equalTo(mapView).inset(20)
            make.leading.equalTo(searchButton.snp.trailing).offset(5)
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
    func setRegion(center: CLLocationCoordinate2D){
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
   

    
    func setAllCustomAnnotation(annotation: [CustomAnnotation]) {
        mapView.addAnnotations(annotation)
    }
    
    func setSearchAnnotation(annotation: MKPointAnnotation) {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    func setOneAnnotation(annotation: CustomAnnotation) {
        let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        mapView.addAnnotation(annotation)
    }
    
    
    func removeAllAnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
    func removeOneAnnotation(annotation: MKPointAnnotation) {
        mapView.removeAnnotation(annotation)
    }
    
   
    
}

extension MainMapView {
    
    func setFloatingPanel(data: PlaceElement) {
        contentVC.viewModel.place.value = data
        fpc.set(contentViewController: contentVC)
        //fpc.isRemovalInteractionEnabled = true
        fpc.view.frame = contentVC.view.bounds
        fpc.layout = FloatingPanelCustomLayout()
        fpc.invalidateLayout()
    }
    
}
