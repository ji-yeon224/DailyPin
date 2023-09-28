//
//  MainMapView.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/26.
//

import UIKit
import MapKit

final class MainMapView: BaseView {
    

    let mapView = MKMapView()
    let textField = {
        let view = SearchTextField()
        view.placeholder = "searchPlaceholder".localized()
        return view
    }()
    let calendarButton = CalendarButton()
    let currentLocation = MyLocationButton()
    
    override func configureUI() {
        addSubview(mapView)
        mapView.addSubview(textField)
        mapView.addSubview(calendarButton)
        mapView.addSubview(currentLocation)
        
        
        
        
    }
    
    override func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        textField.snp.makeConstraints { make in
            make.leading.equalTo(mapView).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(50)
        }
        calendarButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(20)
            make.leading.equalTo(textField.snp.trailing).offset(5)
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
    
    func setRegion(center: CLLocationCoordinate2D){
        
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    func setAnnotation(center: CLLocationCoordinate2D) {
        removeAllAnotation()
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
        
        
    }
    
    func removeAllAnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
}
