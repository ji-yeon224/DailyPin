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
    let uiview = {
        let view = UIView()
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = .zero
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 1
        return view
    }()
    let searchBar = {
        let view = SearchBar()//UISearchBar()
        view.placeholder = "searchPlaceholder".localized()
        return view
    }()
    let calendarButton = CalendarButton()
    let currentLocation = MyLocationButton()
    
    override func configureUI() {
        addSubview(mapView)
        mapView.addSubview(uiview)
        uiview.addSubview(searchBar)
        mapView.addSubview(calendarButton)
        mapView.addSubview(currentLocation)
        
        
        
        
    }
    
    override func setConstraints() {
        
        mapView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        uiview.snp.makeConstraints { make in
            make.leading.equalTo(mapView).inset(20)
            make.top.equalTo(safeAreaLayoutGuide).offset(10)
            make.height.equalTo(50)
        }
        searchBar.snp.makeConstraints { make in
            make.edges.equalTo(uiview)
        }
        calendarButton.snp.makeConstraints { make in
            make.trailing.equalTo(mapView).inset(20)
            make.leading.equalTo(searchBar.snp.trailing).offset(5)
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
    
    func searchResultAnnotation(center: CLLocationCoordinate2D, title: String) {
        removeAllAnotation()
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = title
        mapView.addAnnotation(annotation)
    }
    
    func removeAllAnotation() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
    }
    
}
