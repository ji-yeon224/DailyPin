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
    var items: [Record] = []
    let recordItems = PublishSubject<[Record]>()
    let recordSectionItme = PublishSubject<[RecordSectionModel]>()
    let errorMsg = PublishSubject<String>()
    
    func getRecordItems(place: PlaceItem?) {
        guard let place = place else {
            errorMsg.onNext(InvalidError.noExistData.localizedDescription)
            return
        }
        do {
            items = try placeRepository.getRecordList(id: place.id)
            recordSectionItme.onNext([RecordSectionModel(section: 0, items: items)])
            recordItems.onNext(items)
        } catch {
            errorMsg.onNext("toase_recordLoadError".localized())
        }
    }
    
    
    
}
