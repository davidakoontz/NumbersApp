//
//  CounterFeature.swift
//  PWpro
//
//  Created by David on 7/13/24.
//

// TCA Getting Started - guide
// See:  https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/gettingstarted

import Foundation
import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
        var isLoading = false
        var isTimerRunning = false
        
    }
    
    enum Action {
        case decrementButtonTapped
        case numberFactButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
        
    }
    
    enum CancelID { case timer }
    
    @Dependency(\.continuousClock) var clock
    @Dependency(\.numberFact) var numberFact
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
           
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    state.numberFact = nil
                    return .none
                  
                case .numberFactButtonTapped:
                    state.numberFact = nil
                    state.isLoading = true
                    return .run { [count = state.count] send in
                        try await send(.factResponse(self.numberFact.fetch(count)))
                    }
                    
//                case .numberFactButtonTapped:
//                    state.numberFact = nil
//                    state.isLoading = true
//                    return .run { [count = state.count] send in
//                        let (data, _) = try await URLSession.shared
//                            .data(from: URL(string: "http://numbersapi.com/\(count)")!)
//                        let fact = String(decoding: data, as: UTF8.self)
//                        await send(.factResponse(fact))
//                    }
                    
                case let .factResponse(fact):
                    state.numberFact = fact
                    state.isLoading = false
                    return .none
                    
                case .incrementButtonTapped:
                    state.count += 1
                    state.numberFact = nil
                    return .none
                    
                case .timerTick:
                    state.count += 1
                    state.numberFact = nil
                    return .none
                    
                case .toggleTimerButtonTapped:
                    state.isTimerRunning.toggle()
                    if state.isTimerRunning {
                        return .run { send in
                            for await _ in self.clock.timer(interval: .seconds(1)) {
                                await send(.timerTick)
                            }
                        }
                        .cancellable(id: CancelID.timer)
                    } else {
                        return .cancel(id: CancelID.timer)
                    }
            }   // switch
        }   // reduce

    }   // var body
    
}

