//
//  RecordViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/18.
//

import Foundation

final class RecordViewModel {
    
    private let placeRepository = PlaceRepository()
    private let recordRepository = RecordRepository()
    var errorDescription: Observable<String?> = Observable(nil)
    var currentRecord: Record? = nil
    var currentLocation: PlaceElement? = nil
    
    // 기존에 저장된 장소가 있다면 읽어오기, 없으면 장소 새로 저장하기(savePlace)
    func getPlace(_ data: PlaceElement) -> Place? {
        
        if placeRepository.isExistPlace(id: data.id) {
            do {
                return try placeRepository.searchItemByID(data.id)
            } catch {
                errorDescription.value = error.localizedDescription
                return nil
            }
        } else { // 기존에 저장된 데이터가 없으면 저장해서 리턴
            return savePlace(data)
//            do {
//                return try savePlace(data)
//            } catch let error {
//                throw error
//            }
            
        }
        
        
    }
    
    // 새로운 장소 저장
    func savePlace(_ location: PlaceElement?) -> Place? {
        
        guard let data = location else {
            errorDescription.value = InvalidError.noExistData.errorDescription
            return nil
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        do {
            try placeRepository.createItem(place)
            NotificationCenter.default.post(name: Notification.Name.databaseChange, object: nil, userInfo: ["changeType": "save"])
            
            return place
        } catch {
            errorDescription.value = DataBaseError.createError.errorDescription
            return nil
        }
        
    }
    
    func updateRecord(_ record: Record) {
        guard let currentRecord = currentRecord else {
            errorDescription.value = InvalidError.noExistData.errorDescription
            return
        }
        do {
            try recordRepository.updateRecord(id: currentRecord.objectID, record)
            self.currentRecord = record
        } catch {
            errorDescription.value = error.localizedDescription
            self.currentRecord = nil
        }
    }
    
    func createRecord(_ record: Record) {
        
        guard let location = currentLocation else {
            errorDescription.value = InvalidError.noExistData.errorDescription
            return
        }
        
        guard let place = getPlace(location) else {
            return
        }
        
        do {
            try placeRepository.updateRecordList(record: record, place: place)
            currentRecord = record
        } catch {
            errorDescription.value = error.localizedDescription
        }
    }
    
    func deleteRecord(record: Record) throws {
        
        
        do {
            try recordRepository.deleteItem(record)
            NotificationCenter.default.post(name: Notification.Name.updateCell, object: nil)
        } catch {
            throw error
        }
    }
    
    func deletePlace(id: String) {
        if placeRepository.getRecordListCount(id: id) == 0 {
            
            var deletePlace: Place
            do {
                deletePlace = try placeRepository.searchItemByID(id)
                
            } catch {
                errorDescription.value = error.localizedDescription
                return
            }
            
            do {
                try placeRepository.deleteItem(deletePlace)
            } catch {
                errorDescription.value = error.localizedDescription
                return
            }
            
            NotificationCenter.default.post(name: Notification.Name.databaseChange, object: nil, userInfo: ["changeType": "delete"])
        }
    }
    
    
    
}
