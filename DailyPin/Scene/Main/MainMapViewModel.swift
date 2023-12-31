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
    var placeList: [Place]? = nil
    
    func requestSelectedLocation(lat: Double, lng: Double, completion: @escaping((PlaceElement) -> Void), failCompletion: @escaping((NetworkError) -> Void) ) {
        
        GoogleNetwork.shared.requestGeocoder(api: .geocoding(lat: lat, lng: lng)) { response in
            switch response {
            case .success(let data):
                self.placeInfo = data.results[0]
                self.convertToPlaceElement(placeInfo: self.placeInfo, lat: lat, lng: lng)
                completion(self.selectedLocation!)
            case .failure(let error):
                failCompletion(error)
            }
        }
        
    }
    

    
    private func convertToPlaceElement(placeInfo: PlaceInfo, lat: Double, lng: Double) {
        
        let location = Location(latitude: lat, longitude: lng)
        let addressCompnents = placeInfo.addressComponents
        var name: String = ""
        if placeInfo.addressComponents.count < 2 {
            name = "\(addressCompnents[0].longName)"
        } else {
            name = "\(addressCompnents[1].longName) \(addressCompnents[0].longName)"
        }
        
        let placeName = DisplayName(placeName: name)
        
        selectedLocation = PlaceElement(id: placeInfo.placeID, formattedAddress: placeInfo.address, location: location, displayName: placeName)
        
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
        return PlaceElement(id: place.placeId, formattedAddress: place.address, location: Location(latitude: place.latitude, longitude: place.longitude), displayName: DisplayName(placeName: place.placeName))
    }
    
    
    
    
    
    
    
}
