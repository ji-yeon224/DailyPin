//
//  NetworkMonitor.swift
//  DailyPin
//
//  Created by 김지연 on 2023/10/10.
//

import UIKit
import Network
import RxSwift

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    private let monitor: NWPathMonitor
    
    var isConnected:Bool = false
    private var monitorRun: Bool = false
    let connected = PublishSubject<Bool>()
    // monotior 초기화
    private init() {
        monitor = NWPathMonitor()
    }
    
    private func monitoring() {
        monitor.start(queue: .global())
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            self.isConnected = path.status == .satisfied
            
            if self.isConnected == true{
                DispatchQueue.main.async {
                    self.connected.onNext(true)
                }
                
            }else{
                
                DispatchQueue.main.async {
                    self.connected.onNext(false)
                }
            }
        }
        
        
    }
    
    func startMonitoring() {
        if !monitorRun {
            monitorRun = true
            monitoring()
        }
    }
    
    
    // Network Monitoring 종료
    func stopMonitoring() {
        if monitorRun {
            monitorRun.toggle()
            monitor.cancel()
        }
        
    }
    
    
}
