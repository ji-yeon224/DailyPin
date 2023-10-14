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
    private var placeInfo: PlaceInfo = PlaceInfo(addressComponents: [], address: "", placeID: "")
    var selectedLocation: PlaceElement? = nil
    
    
    func requestSelectedLocation(lat: Double, lng: Double, completion: @escaping(() -> Void), failCompletion: @escaping(() -> Void) ) {
        GoogleNetwork.shared.requestGeocoder(lat: lat, lng: lng) { response in
            switch response {
            case .success(let data):
                self.placeInfo = data.results[0]
                self.convertToPlaceElement(placeInfo: self.placeInfo, lat: lat, lng: lng)
                completion()
            case .failure(let _):
                failCompletion()
            }
        }
    }
    
    private func convertToPlaceElement(placeInfo: PlaceInfo, lat: Double, lng: Double) {
        
        let location = Location(latitude: lat, longitude: lng)
        let name = "\(placeInfo.addressComponents[1].longName) \(placeInfo.addressComponents[0].longName)"
        let placeName = PlaceName(placeName: name)
        
        selectedLocation = PlaceElement(id: placeInfo.placeID, formattedAddress: placeInfo.address, location: location, placeName: placeName)
        
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
    
    func convertPlaceToPlaceElement(place: Place) -> PlaceElement {
        return PlaceElement(id: place.placeId, formattedAddress: place.address, location: Location(latitude: place.latitude, longitude: place.longitude), placeName: PlaceName(placeName: place.placeName))
    }
    
    
    
    
    
    
    
}
