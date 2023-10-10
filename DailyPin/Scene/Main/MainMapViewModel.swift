//
//  MainMapViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation
import MapKit

final class MainMapViewModel {
    
    private let placeRepository = PlaceRepository()
    
    let place: Observable<[Place]?> = Observable(nil)
    let annotations: Observable<[CustomAnnotation]> = Observable([])
    
    func getAllPlaceAnnotation() {
        
        place.value = placeRepository.fetch()
        setAllAnnotations()
        
    }
    
    func setAllAnnotations() {
        
        if let place = place.value {
            annotations.value.removeAll()
            place.forEach {
                let coord = CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)
                
                let customAnnotation = CustomAnnotation(placeID: $0.placeId, coordinate: coord)
                annotations.value.append(customAnnotation)
            }
        }
        
    }
    
}
