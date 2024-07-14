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
            if !_XCTIsTesting {
                // Your real root view
                
                CounterFeatureView(
                    store: Store(initialState: CounterFeature.State()) {
                        CounterFeature()
                    }
                )
                //If TESTING, you can omit the entire entry point of your application:
            }   // if Not Testing
        }
        
    }
}
