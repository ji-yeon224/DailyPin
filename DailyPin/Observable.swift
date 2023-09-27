//
//  Observable.swift
//  DailyPin
//
//  Created by 김지연 on 2023/09/27.
//

import Foundation

class Observable<T> {
    
    init(_ value: T) {
        self.value = value
    }
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    func bind(_ closure: @escaping (T) -> Void ) {
        closure(value)
        listener = closure
    }
    
}
