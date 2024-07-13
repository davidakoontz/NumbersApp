//
//  PWproApp.swift
//  PWpro
//
//  Created by David on 7/13/24.
//

import SwiftUI
import ComposableArchitecture

@main
struct PWproApp: App {
    var body: some Scene {
        WindowGroup {
            //ContentView()
            CounterFeatureView(
                store: Store(initialState: CounterFeature.State()) {
                    CounterFeature()
                }
            )
        }
        
    }
}
