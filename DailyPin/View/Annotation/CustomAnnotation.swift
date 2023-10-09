//
//  CustomAnnotation.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/08.
//

import Foundation
import MapKit



final class CustomAnnotation: NSObject, MKAnnotation {
    
    let placeID: String
    @objc dynamic var coordinate: CLLocationCoordinate2D
    
    init(placeID: String, coordinate: CLLocationCoordinate2D) {
        self.placeID = placeID
        self.coordinate = coordinate
        super.init()
    }
    
}
