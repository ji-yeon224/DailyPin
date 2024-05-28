//
//  ResponseProtocol.swift
//  DailyPin
//
//  Created by 김지연 on 5/28/24.
//

import Foundation
protocol ResponseProtocol: Decodable {
    associatedtype ResponseType: ModelTypeProtocol
    func toDomain() -> ResponseType
    
}
