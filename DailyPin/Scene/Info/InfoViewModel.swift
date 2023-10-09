//
//  InfoViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/02.
//

import Foundation
import RealmSwift

final class InfoViewModel {
    
    private let placeRepository = PlaceRepository()
    
    let placeName: Observable<String?> = Observable(nil)
    let place: Observable<PlaceElement?> = Observable(nil)
    let recordList: Observable<Results<Record>?> = Observable(nil)
    
    func getRecordList() throws {
        
        guard let place = place.value else {
            throw InvalidError.noExistData
        }
        
        recordList.value = nil
        do {
            recordList.value = try placeRepository.getRecordList(id: place.id)
        } catch {
            recordList.value = nil
            return
        }
        
        //print(recordList.value)
        
    }
    
    
}
