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
    let allPlace = PublishSubject<[PlaceItem]>()
    
    let allAnnotations = PublishSubject<[CustomAnnotation]>()
    var allAnnotationList: [CustomAnnotation] = []
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
        
        let item = placeRepository.fetch()
        allPlace.onNext(item)
        setAllAnnotations(item: item)
        
    }
    
    private func setAllAnnotations(item: [PlaceItem]) {
        allAnnotationList.removeAll()
        item.forEach {
            if let lat = $0.latitude, let lng = $0.longitude {
                let coord = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                
                let customAnnotation = CustomAnnotation(placeID: $0.id, coordinate: coord)
                allAnnotationList.append(customAnnotation)
            }
        }
        
        allAnnotations.onNext(allAnnotationList)
        
    }
    
    func getPlaceData(id: String) -> PlaceItem? {
        
        do {
            let place = try placeRepository.searchItemByID(id)
            return place.toDomain()
        } catch {
            return nil
        }
    }
    
    func convertPlaceToPlaceElement(place: Place) -> PlaceItem {
        return place.toDomain()
    }
    
    
    
    
    
    
    
}
