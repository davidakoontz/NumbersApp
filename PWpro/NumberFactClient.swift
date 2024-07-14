//
//  NumberFactClient.swift
//  PWpro
//
//  Created by David on 7/13/24.
//

import Foundation
import ComposableArchitecture

/*
 Tip
 While protocols are by far the most popular way of abstracting dependency interfaces, they are not the only way. We prefer to use structs with mutable properties to represent the interface, and then construct values of the struct to represent conformances. You can use protocols for your dependencies if you so wish, but if you are interested in learning more about the struct style, see our series of videos for more information.
 
 Go back to CounterFeature.swift and add a new dependency using the @Dependency property wrapper, but this time for the number fact client. Then, in the effect returned from factButtonTapped, use the numberFact dependency to load the fact rather than reaching out to URLSession to make a live network request.
 */
struct NumberFactClient {
    var fetch: (Int) async throws -> String
}

/*
 Register your dependency with the library, which requires two steps. First you conform the client to the DependencyKey protocol, which requires you to provide a liveValue. This is the value used when your feature is run in simulators and devices, and it’s the place where it is appropriate to make live network requests.
 */
extension NumberFactClient: DependencyKey {
    // get live data from API at http://numbersapi.com
    static let liveValue = Self(
        fetch: { number in
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "http://numbersapi.com/\(number)")!)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

/*
 The second step to registering the dependency with the library is to add a computed property to DependencyValues with a getter and a setter. This is what allows for the syntax @Dependency(\.numberFact) in the reducer.
 */
extension DependencyValues {
    var numberFact: NumberFactClient {
        get { self[NumberFactClient.self] }
        set { self[NumberFactClient.self] = newValue }
    }
}
