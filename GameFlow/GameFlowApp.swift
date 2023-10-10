//
//  GameFlowApp.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct GameFlowApp: App {
    var body: some Scene {
        WindowGroup {
            GameList(store: Store(initialState: Search.State(),
                                  reducer: {
                                    Search()}))
        }
    }
}
