//
//  NotificationCenterProtocol.swift
//  DailyPin
//
//  Created by 김지연 on 6/12/24.
//

import Foundation
import RxSwift

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
    
}

extension NotificationCenterProtocol {
    func addObserver() -> RxSwift.Observable<Notification> {
        return NotificationCenter.default.rx.notification(name)
    }
    
    func post(userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
    
}
