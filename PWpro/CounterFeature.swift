//
//  CounterFeature.swift
//  PWpro
//
//  Created by David on 7/13/24.
//

// TCA Getting Started - guide
// See:  https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/gettingstarted
import ComposableArchitecture
import Foundation
import SwiftUI

@Reducer
struct CounterFeature {
    @ObservableState
    struct State: Equatable {
        var count = 0
        var numberFact: String?
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
        case numberFactButtonTapped
        case numberFactResponse(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                    state.count -= 1
                    return .none
                    
                    
                case .incrementButtonTapped:
                    state.count += 1
                    return .none
                    
                    
                case .numberFactButtonTapped:
                    return .run { [count = state.count] send in
                        let (data, _) = try await URLSession.shared.data(
                            from: URL(string: "http://numbersapi.com/\(count)/trivia")!
                        )
                        await send(
                            .numberFactResponse(String(decoding: data, as: UTF8.self))
                        )
                    }
                    
                    
                case let .numberFactResponse(fact):
                    state.numberFact = fact
                    return .none
            }
        }
    }
}

struct CounterFeatureView: View {
    let store: StoreOf<CounterFeature>
    
    
    var body: some View {
        Form {
            Section {
                Text("\(store.count)")
                Button("Decrement") { store.send(.decrementButtonTapped) }
                Button("Increment") { store.send(.incrementButtonTapped) }
            }
            
            
            Section {
                Button("Number fact") { store.send(.numberFactButtonTapped) }
            }
            
            if let fact = store.numberFact {
                Text(fact)
            }
        }
    }
}


#Preview {
    CounterFeatureView(store: Store(initialState:CounterFeature.State()) {
        
        CounterFeature()
    })
}

