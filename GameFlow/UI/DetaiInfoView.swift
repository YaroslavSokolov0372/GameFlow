//
//  DetaiInfoView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct GameDetailInfoDomain: Reducer {
    
    struct State {
        var matches = ""
        var isFollowing = false
    }
    
    enum Action {
        case followToggleOn
        case followToggleOff
    }
    
    var body: some Reducer<State, Action> {

        
        Reduce { state, action in
            switch action {
            default: return .none
            }
        }
    }
}





struct DetaiInfoView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    DetaiInfoView()
}
