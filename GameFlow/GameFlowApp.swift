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
//            GameList(store: Store(initialState: GameListDomain.State(),
//                                  reducer: {
//                                    GameListDomain()}))
            MainView(store: Store(initialState: MainDomain.State(), reducer: {
                MainDomain()
            }))
//            SeriesListView(store: Store(initialState: SeriesListDomain.State(), reducer: {
//                SeriesListDomain()
//            }))
        }
    }
}
