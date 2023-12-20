//
//  RecordViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/18.
//

import Foundation
import RxSwift
import RxCocoa

final class RecordViewModel {
    
    private let placeRepository = PlaceRepository()
    private let recordRepository = RecordRepository()
    
    private let disposeBag = DisposeBag()
    
    
    
    var currentRecord: Record? = nil
    var currentLocation: PlaceElement? = nil
    
    
    struct Input {
        let createRecord: PublishRelay<Record>
        let updateRecord: PublishRelay<Record>
        let deleteRecord: PublishRelay<Record>
    }
    
    struct Output {
        let successCreate: PublishRelay<String>
        let errorMsg: PublishRelay<String>
        let successDelete: PublishRelay<(String, Bool)>
    }
    
    func transform(input: Input) -> Output {
        let errorMsg = PublishRelay<String>()
        let successMsg = PublishRelay<String>()
        let successDelete = PublishRelay<(String, Bool)>()
        let deletePlace = PublishRelay<String>()
        
        input.createRecord
            .bind(with: self) { owner, value in
                guard let location = owner.currentLocation else {
                    errorMsg.accept(InvalidError.noExistData.localizedDescription)
                    return
                }
                
                guard let place = owner.getPlace(location) else {
                    return
                }
                
                do {
                    try owner.placeRepository.updateRecordList(record: value, place: place)
                    owner.currentRecord = value
                    successMsg.accept("저장을 완료하였습니다.")
                } catch {
                    print("error")
                    errorMsg.accept(error.localizedDescription)
                }
                
            }
            .disposed(by: disposeBag)
        
        input.updateRecord
            .bind(with: self) { owner, value in
                guard let currentRecord = owner.currentRecord else {
                    errorMsg.accept(InvalidError.noExistData.localizedDescription)
                    return
                }
                do {
                    try owner.recordRepository.updateRecord(id: currentRecord.objectID, value)
                    owner.currentRecord = value
                    
                    successMsg.accept("수정을 완료하였습니다.")
                } catch {
                    errorMsg.accept(error.localizedDescription)
//                    self.currentRecord = nil
                }
            }
            .disposed(by: disposeBag)
        
        input.deleteRecord
            .bind(with: self) { owner, value in
                do {
                    try owner.recordRepository.deleteItem(value)
                    guard let location = owner.currentLocation else {
                        return
                    }
                    deletePlace.accept(location.id)
                    
                } catch {
                    errorMsg.accept(error.localizedDescription)
                }
                
                
            }
            .disposed(by: disposeBag)
        
        deletePlace
            .bind(with: self) { owner, value in
                var refresh = false
                if owner.placeRepository.getRecordListCount(id: value) == 0 {
                    var deletePlace: Place
                    do {
                        deletePlace = try owner.placeRepository.searchItemByID(value)
                    } catch {
                        errorMsg.accept(error.localizedDescription)
                        return
                    }
                    
                    do {
                        try owner.placeRepository.deleteItem(deletePlace)
                    } catch {
                        errorMsg.accept(error.localizedDescription)
                        return
                    }
                    
                    refresh = true
                }
                successDelete.accept(("삭제를 완료하였습니다.", refresh))
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            successCreate: successMsg,
            errorMsg: errorMsg,
            successDelete: successDelete
        )
    }
    
    
    
    
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
        }
        
        
    }
    
    var errorDescription: Observable<String?> = Observable(nil)
    
    func savePlace(_ location: PlaceElement?) -> Place? {
        
        guard let data = location else {
            errorDescription.value = InvalidError.noExistData.errorDescription
            return nil
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        do {
            try placeRepository.createItem(place)
            NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "save"])
            
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
    
//    private func createRecord(_ record: Record) {
//        
//        guard let location = currentLocation else {
//            errorDescription.value = InvalidError.noExistData.errorDescription
//            return
//        }
//        
//        guard let place = getPlace(location) else {
//            return
//        }
//        
//        do {
//            try placeRepository.updateRecordList(record: record, place: place)
//            currentRecord = record
//            self.successMsg.accept("저장을 완료하였습니다.")
//        } catch {
//            errorDescription.value = error.localizedDescription
//            errorMsg.accept(error.localizedDescription)
//        }
//    }
    
//    func deleteRecord(record: Record) throws {
//        
//        
//        do {
//            try recordRepository.deleteItem(record)
//            NotificationCenter.default.post(name: .updateCell, object: nil)
//        } catch {
//            throw error
//        }
//    }
//    
//    func deletePlace(id: String) {
//        if placeRepository.getRecordListCount(id: id) == 0 {
//            
//            var deletePlace: Place
//            do {
//                deletePlace = try placeRepository.searchItemByID(id)
//                
//            } catch {
//                errorDescription.value = error.localizedDescription
//                return
//            }
//            
//            do {
//                try placeRepository.deleteItem(deletePlace)
//            } catch {
//                errorDescription.value = error.localizedDescription
//                return
//            }
//            
//            NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "delete"])
//        }
//    }
//    
    
    
}
