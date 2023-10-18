//
//  RecordViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/18.
//

import Foundation

final class RecordViewModel {
    
    private let placeRepository = PlaceRepository()
    
    
    func saveRecord(record: Record?) {
        
        
        
    }
    
    
    // 기존에 저장된 장소가 있다면 읽어오기, 없으면 장소 새로 저장하기(savePlace)
    func getPlace(_ data: PlaceElement) throws -> Place {
        
        if placeRepository.isExistPlace(id: data.id) {
            do {
                return try placeRepository.searchItemByID(data.id)
            } catch let error {
                throw error
            }
        } else { // 기존에 저장된 데이터가 없으면 저장해서 리턴
            do {
                return try savePlace(data)
            } catch let error {
                throw error
            }
            
        }
        
        
    }
    
    // 새로운 장소 저장
    func savePlace(_ location: PlaceElement?) throws -> Place {
        
        guard let data = location else {
            
            throw InvalidError.noExistData
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        do {
            try placeRepository.createItem(place)
            NotificationCenter.default.post(name: Notification.Name.databaseChange, object: nil, userInfo: ["changeType": "save"])
            
            return place
        } catch {
            throw DataBaseError.createError
        }
        
    }
    
    
    
}
