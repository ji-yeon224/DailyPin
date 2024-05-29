//
//  MainMapViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation
import MapKit
import RxSwift

final class MainMapViewModel {
    
    private let placeRepository = PlaceRepository()
    
    let searchError = PublishSubject<String>()
    let geoInfo = PublishSubject<PlaceItem>()
    
    let place: Observable<[Place]?> = Observable(nil)
    let annotations: Observable<[CustomAnnotation]> = Observable([])
    
    var selectedLocation: PlaceItem? = nil
    
    
    func requestGeocoding(lat: Double, lng: Double) {
        Task {
            do {
                let item = try await GoogleNetwork.shared.requestData(api: .geocoding(lat: lat, lng: lng), resultType: GeocodingResDto.self)
                guard let item = item as? PlaceItemList else { return }
                var info = item.item[0]
                info.latitude = lat
                info.longitude = lng
                geoInfo.onNext(info)
                selectedLocation = info
            } catch {
                searchError.onNext(error.localizedDescription)
            }
        }
    }
    
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
    
    func getPlaceData(id: String) -> Place? {
        
        do {
            let place = try placeRepository.searchItemByID(id)
            return place
        } catch {
            return nil
        }
    }
    
    func convertPlaceToPlaceElement(place: Place) -> PlaceItem {
        return place.toDomain()
    }
    
    
    
    
    
    
    
}
