//
//  AppFeatureTests.swift
//  PWproTests
//
//  Created by David on 7/14/24.
//

import XCTest
import ComposableArchitecture

@testable import PWpro

@MainActor
final class AppFeatureTests: XCTestCase {


    func testIncrementInFirstTab() async {
        let store = TestStore(initialState: AppFeature.State()) {
            AppFeature()
        }
        
        await store.send(\.tab1.incrementButtonTapped) {
            $0.tab1.count = 1   //mutate the previous version of the feature state
                                //so that it matches the state after the action is sent.
        }
    }
}
