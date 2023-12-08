//
//  GameFlowApp.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Firebase

@main
struct GameFlowApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    
    
    var body: some Scene {
        WindowGroup {
            
            MainView(store: Store(initialState: MainDomain.State(), reducer: {
                MainDomain()
            }))
            
//            MainResketch(store: Store(initialState: MainResketchDomain.State(), reducer: {
//                MainResketchDomain()
//            }))
        }
    }
}
