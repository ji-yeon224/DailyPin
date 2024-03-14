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
        let createRecord: PublishRelay<(Record, PlaceElement)>
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
                    successMsg.accept("toast_saveComplete".localized())
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
    private func getPlace(_ data: PlaceElement) -> Place? {
        
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
    
    
    private func savePlace(_ location: PlaceElement?) -> Place? {
        
        guard let data = location else {
            return nil
        }
        
        let place = Place(placeId: data.id, address: data.formattedAddress, placeName: data.displayName.placeName, latitude: data.location.latitude, longitude: data.location.longitude)
        
        
        do {
            try placeRepository.createItem(place)
            NotificationCenter.default.post(name: .databaseChange, object: nil, userInfo: ["changeType": "save"])
            
            return place
        } catch {
            return nil
        }
        
    }
}
