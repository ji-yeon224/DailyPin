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
    
    
    
    
    
}
