//
//  PlaceInfo.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/03.
//

import Foundation
import RealmSwift

final class Place: Object {
    @Persisted(primaryKey: true) var placeId: String
    @Persisted var address: String
    @Persisted var placeName: String
    @Persisted var latitude: Double
    @Persisted var longitude: Double
    @Persisted var recordList: List<Record>
    
    
    convenience init(placeId: String, address: String, placeName: String, latitude: Double, longitude: Double) {
        self.init()
        
        self.placeId = placeId
        self.address = address
        self.placeName = placeName
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
