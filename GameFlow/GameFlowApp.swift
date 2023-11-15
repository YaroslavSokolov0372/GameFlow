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
//        
//        let providerFactory = AppCheckDebugProviderFactory()
//        AppCheck.setAppCheckProviderFactory(providerFactory)
        
        
        FirebaseApp.configure()
        
    }
    
    var body: some Scene {
        WindowGroup {
//            MainView(store: Store(initialState: MainDomain.State(), reducer: {
//                MainDomain()
//            }))
            
//            TestWrite(store: Store(initialState: TestWriteDomain.State(), reducer: {
//                TestWriteDomain()
//            }))
            
            MainResketch(store: Store(initialState: MainResketchDomain.State(), reducer: {
                MainResketchDomain()
            }))
        }
    }
}
