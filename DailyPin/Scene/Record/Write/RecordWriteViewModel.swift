//
//  RecordWriteViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RecordWriteViewModel {
    private let placeRepository = PlaceRepository()
    private let recordRepository = RecordRepository()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let createRecord: PublishRelay<(Record, PlaceItem)>
        let updateRecord: PublishRelay<(Record, Record)>
        
    }
    
    struct Output {
        let msg: PublishRelay<String>
        let successMsg: PublishRelay<String>
        let updateData: PublishSubject<Record>
    }
    
    func transform(input: Input) -> Output {
        let msg = PublishRelay<String>()
        let successMsg = PublishRelay<String>()
        let updateData = PublishSubject<Record>()
        
        input.createRecord
            .bind(with: self) { owner, value in
                let record = value.0
                let location = value.1
                
                guard let place = owner.getPlace(location) else {
                    return
                }
                
                do {
                    try owner.placeRepository.updateRecordList(record: record, place: place)
                    NotificationCenterManager.updateCell.post()
                    successMsg.accept(LocalizableKey.toast_saveComplete.localized)
                } catch {
                    debugPrint("error")
                    msg.accept(error.localizedDescription)
                }
                
            }
            .disposed(by: disposeBag)
        
        input.updateRecord
            .bind(with: self) { owner, value in
                let record = value.0
                let newData = value.1
                do {
                    let data = try owner.recordRepository.updateRecord(id: record.objectID, newData)
                    updateData.onNext(data)
                    NotificationCenterManager.updateCell.post()
                } catch {
                    msg.accept(error.localizedDescription)
//                    self.currentRecord = nil
                }
            }
            .disposed(by: disposeBag)
        
        return Output(
            msg: msg,
            successMsg: successMsg,
            updateData: updateData
        )
    }
    
}

extension RecordWriteViewModel {
    // 기존에 저장된 장소가 있다면 읽어오기, 없으면 장소 새로 저장하기(savePlace)
    private func getPlace(_ data: PlaceItem) -> Place? {
        
        if placeRepository.isExistPlace(id: data.id) {
            do {
                return try placeRepository.searchItemByID(data.id)
            } catch {
                
                return nil
            }
        } else { // 기존에 저장된 데이터가 없으면 저장해서 리턴
            return savePlace(data)
        }
        
        
    }
    
    
    private func savePlace(_ location: PlaceItem?) -> Place? {
        
        guard let location = location, let lat = location.latitude, let lng = location.longitude else {
            return nil
        }
        
        let place = Place(placeId: location.id, address: location.address, placeName: location.name, latitude: lat, longitude: lng)
        
        
        do {
            try placeRepository.createItem(place)
            
            NotificationCenterManager.databaseChange.post(userInfo: [NotificationKey.changeType: ChangeType.save])
            
            return place
        } catch {
            return nil
        }
        
    }
}
