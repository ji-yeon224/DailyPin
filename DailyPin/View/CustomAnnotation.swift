//
//  CustomAnnotation.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/08.
//

import Foundation
import UIKit
import MapKit
import SnapKit

class CustomAnnotationView: MKAnnotationView {
    
    static let identifier = "CustomAnnotationView"
    
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        frame = CGRect(x: 0, y: 0, width: 40, height: 50)
        centerOffset = CGPoint(x: 0, y: -frame.size.height / 2)
        
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
}

class CustomAnnotation: NSObject, MKAnnotation {
    
    let placeID: String
    let coordinate: CLLocationCoordinate2D
    
    init(placeID: String, coordinate: CLLocationCoordinate2D) {
        self.placeID = placeID
        self.coordinate = coordinate
        super.init()
    }
    
}
