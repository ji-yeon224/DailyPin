//
//  NetworkMonitor.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import Foundation
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
                //print("연결이된 상태임!")
            }else{
                //print("연결 안된 상태임!")
                
            }
            
        }
    }
    

    // Network Monitoring 종료
    public func stopMonitoring() {
        monitor.cancel()
    }

    // Network 연결 타입
    
}
