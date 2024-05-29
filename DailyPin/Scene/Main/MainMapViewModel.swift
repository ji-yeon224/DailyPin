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
    private var placeInfo: GeocodeData = GeocodeData(addressComponents: [], address: "", placeID: "")
    var selectedLocation: PlaceItem? = nil
//    var placeList: [Place]? = nil
    
    
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
    
    func requestSelectedLocation(lat: Double, lng: Double, completion: @escaping((PlaceItem) -> Void), failCompletion: @escaping((NetworkError) -> Void) ) {
        
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
    

    
    private func convertToPlaceElement(placeInfo: GeocodeData, lat: Double, lng: Double) {
        
        let location = Location(latitude: lat, longitude: lng)
        let addressCompnents = placeInfo.addressComponents
        var name: String = ""
        if placeInfo.addressComponents.count < 2 {
            name = "\(addressCompnents[0].longName)"
        } else {
            name = "\(addressCompnents[1].longName) \(addressCompnents[0].longName)"
        }
        
//        let placeName = DisplayName(placeName: name)
        
        selectedLocation = PlaceItem(id: placeInfo.placeID, address: placeInfo.address, latitude: lat, longitude: lng, name: name)
        //PlaceElement(id: placeInfo.placeID, formattedAddress: placeInfo.address, location: location, displayName: placeName)
        
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
//        return PlaceElement(id: place.placeId, formattedAddress: place.address, location: Location(latitude: place.latitude, longitude: place.longitude), displayName: DisplayName(placeName: place.placeName))
    }
    
    
    
    
    
    
    
}
