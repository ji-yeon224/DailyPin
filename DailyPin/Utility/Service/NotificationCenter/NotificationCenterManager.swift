//
//  NotificationManager.swift
//  DailyPin
//
//  Created by 김지연 on 6/12/24.
//

import Foundation
enum NotificationCenterManager: NotificationCenterProtocol {
    case databaseChange
    case updateCell
    case networkConnect
    
    var name: Notification.Name {
        switch self {
        case .databaseChange:
            return NSNotification.Name("databaseChange")
        case .updateCell:
            return NSNotification.Name("updateCell")
        case .networkConnect:
            return NSNotification.Name("networkConnect")
        }
    }
}
