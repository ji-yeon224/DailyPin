//
//  RecordReadViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 3/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class RecordReadViewModel {
    private let placeRepository = PlaceRepository()
    private let recordRepository = RecordRepository()
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let deleteRecord: PublishRelay<(Record, PlaceElement)>
    }
    struct Output {
        let msg: PublishRelay<String>
        let successDelete: PublishRelay<(String, Bool)>
    }
    
    func transform(input: Input) -> Output {
        let msg = PublishRelay<String>()
        let successDelete = PublishRelay<(String, Bool)>()
        let deletePlace = PublishRelay<String>()
        
        input.deleteRecord
            .bind(with: self) { owner, value in
                let record = value.0
                let location = value.1
                do {
                    try owner.recordRepository.deleteItem(record)
                    
                    deletePlace.accept(location.id)
                    
                } catch {
                    msg.accept(error.localizedDescription)
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
                        msg.accept(error.localizedDescription)
                        return
                    }
                    
                    do {
                        try owner.placeRepository.deleteItem(deletePlace)
                    } catch {
                        msg.accept(error.localizedDescription)
                        return
                    }
                    
                    refresh = true
                }
                successDelete.accept(("삭제를 완료하였습니다.", refresh))
                
            }
            .disposed(by: disposeBag)
        
        return Output(
            msg: msg,
            successDelete: successDelete
        )
    }
    
}
