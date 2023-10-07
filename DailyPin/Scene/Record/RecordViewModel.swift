//
//  RecordViewModel.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/07.
//

import Foundation
import RealmSwift

final class RecordViewModel {
    
    var title: Observable<String> = Observable("")
    var date: Observable<Date> = Observable(Date())
    var memo: Observable<String?> = Observable(nil)
    
    
    
    
}
