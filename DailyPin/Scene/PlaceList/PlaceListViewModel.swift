//
//  PlaceListViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import Foundation
import RxSwift

final class PlaceListViewModel {
    
    
    private let placeRepository = PlaceRepository()
//    var placeList: Observable<[PlaceItem]> = Observable([])
    var placeItems: [PlaceItem] = []
    let placeList = PublishSubject<[PlaceItem]>()
    
    func getAllPlaceData() {
        placeItems.removeAll()
        placeItems = placeRepository.fetch().map { $0.toDomain() }
        placeList.onNext(placeItems)
//        placeList.value.append(contentsOf: placeRepository.fetch())
    }
    
}
