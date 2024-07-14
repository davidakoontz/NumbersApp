//
//  AppFeature.swift
//  PWpro
//
//  Created by David on 7/14/24.
//

import SwiftUI
import ComposableArchitecture



@Reducer
struct AppFeature {
    struct State: Equatable {
        var tab1 = CounterFeature.State()
        var tab2 = CounterFeature.State()
    }
    enum Action {
        case tab1(CounterFeature.Action)
        case tab2(CounterFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.tab1, action: \.tab1) {
            CounterFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            CounterFeature()
        }
        Reduce { state, action in
            // Core logic of the app feature
            return .none
        }
    }
}

/*
 In its simplest form it starts by composing the reducers together in the body of a parent reducer and using the Scope reducer to focus in on a sub-domain of the parent to run a child reducer.
 */
struct AppView: View {
    let store: StoreOf<AppFeature>
//  https://pointfreeco.github.io/swift-composable-architecture/main/tutorials/composablearchitecture/01-04-composingfeatures#Deriving-child-stores
//    let store1: StoreOf<CounterFeature>
//    let store2: StoreOf<CounterFeature>
    
    var body: some View {
        TabView {
        //    CounterFeatureView(store: store1) // now using KeyPath to scope it
            CounterFeatureView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Text("Counter 1")
                }
            
        //    CounterFeatureView(store: store2)
            CounterFeatureView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Text("Counter 2")
                }
        }
    }
}



#Preview {
    AppView(
        store: Store(initialState: AppFeature.State()) {
            AppFeature()
        }
    )
}
