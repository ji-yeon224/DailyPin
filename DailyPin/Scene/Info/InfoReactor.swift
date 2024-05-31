//
//  InfoReactor.swift
//  DailyPin
//
//  Created by 김지연 on 6/1/24.
//

import Foundation
import ReactorKit

final class InfoReactor: Reactor {
    var initialState: State = State()
    enum Action {
    }
    
    enum Mutation {
        
    }
    
    struct State {
        
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
    }
    func reduce(state: State, mutation: Mutation) -> State {
        return State()
    }
}
