//
//  InfoViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import Foundation
import RxSwift

final class InfoViewModel {
    
    private let placeRepository = PlaceRepository()
    
    let recordItems = PublishSubject<[Record]>()
    let errorMsg = PublishSubject<String>()
    
    func getRecordItems(place: PlaceItem?) {
        guard let place = place else {
            errorMsg.onNext(InvalidError.noExistData.localizedDescription)
            return
        }
        do {
            let items = try placeRepository.getRecordList(id: place.id)
            recordItems.onNext(items)
        } catch {
            errorMsg.onNext("toase_recordLoadError".localized())
        }
    }
    
    
    
}
