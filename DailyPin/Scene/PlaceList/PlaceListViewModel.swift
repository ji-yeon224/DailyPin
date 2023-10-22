//
//  PlaceListViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/22.
//

import Foundation

final class PlaceListViewModel {
    
    
    private let placeRepository = PlaceRepository()
    var placeList: Observable<[Place]> = Observable([])
    
    func getAllPlaceData() {
        placeList.value.removeAll()
        placeList.value.append(contentsOf: placeRepository.fetch())
    }
    
}
