//
//  NetworkMonitor.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import UIKit
import Network

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    public private(set) var isConnected:Bool = false
   
    // monotior 초기화
    private init() {
        monitor = NWPathMonitor()
    }

    func startMonitoring() {
        
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            
            if self?.isConnected == true{
                NotificationCenter.default.post(name: .networkConnect, object: self, userInfo: ["isConnected": true])
            }else{
                NotificationCenter.default.post(name: .networkConnect, object: self, userInfo: ["isConnected": false])
                
                
            }
            
        }
    }
    
    
    // Network Monitoring 종료
    public func stopMonitoring() {
        monitor.cancel()
    }

    
}
