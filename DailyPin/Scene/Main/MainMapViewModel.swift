//
//  MainMapViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation
import MapKit
import RealmSwift

final class MainMapViewModel {
    
    let annotations: Observable<[MKPointAnnotation]> = Observable([])
    
    func setAllAnotation(_ allData: Results<Place>?) {
        
        guard let allData = allData else {
            return
        }
        
        for data in allData {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
            annotations.value.append(annotation)
        }
        
    }
    
    
}
