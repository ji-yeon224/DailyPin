//
//  AuthorizationLocationDelegate.swift
//  DailyPin
//
//  Created by 김지연 on 5/27/24.
//

import Foundation
protocol AuthorizationLocationProtocol: AnyObject {
    func showRequestLocationServiceAlert()
    func failGetUserLoaction(message: String)
    
}
