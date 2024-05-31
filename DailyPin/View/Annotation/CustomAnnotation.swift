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
    var isHighlight: Bool = false
    
    init(placeID: String, coordinate: CLLocationCoordinate2D, isHighlight: Bool = false) {
        self.placeID = placeID
        self.coordinate = coordinate
        self.isHighlight = isHighlight
    }
    
}
