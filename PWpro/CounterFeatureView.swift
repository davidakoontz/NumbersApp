//
//  CounterFeatureView.swift
//  PWpro
//
//  Created by David on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

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

