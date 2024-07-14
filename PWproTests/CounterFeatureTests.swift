//
//  CounterFeatureTests.swift
//  PWproTests
//
//  Created by David on 7/13/24.
//

import ComposableArchitecture
import XCTest


@testable import PWpro


@MainActor
final class CounterFeatureTests: XCTestCase {
    
    func testTimer() async {
        let clock = TestClock()
        
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        } withDependencies: {
            $0.continuousClock = clock
        }
        
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = true
        }
        
        await clock.advance(by: .seconds(1))
        
        await store.receive(\.timerTick) {
            // receive uses a KeyPath
            $0.count = 1
        }
        await store.send(.toggleTimerButtonTapped) {
            $0.isTimerRunning = false
        }
    }
    
    
    func testCounter() async {
        let store = TestStore(initialState: CounterFeature.State()) {
            CounterFeature()
        }
        // emulate user incrementing & decrementing
        /*
         To fix the test failures we need to assert how the state changed after sending each action, and the test store makes this very ergonomic. You only need to provide a trailing closure to the send method, that closure is handed a mutable version of the state before the action was sent, and it’s your job to mutate $0 so that it equals the state after the action is sent.
         */
        await store.send(.incrementButtonTapped) {
            $0.count = 1
            /*
             Prefer to use “absolute” mutations, such as count = 1, rather than “relative” mutations, such as count += 1.
             */
        }
        await store.send(.decrementButtonTapped) {
            $0.count = 0
        }
        
    }
}
