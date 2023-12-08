//
//  MatchDetailResketchView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 27/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct MatchDetailResketchDomain: Reducer {
    
    struct State: Equatable {
        @BindingState var pos: CGFloat = .zero
        @BindingState var prev: CGFloat = 0
        var isStarted: Bool
        let match: PandascoreMatch
        let liquiTeams: [LiquipediaSerie.LiquipediaTeam]
    }
    
    enum Action {
        case posChanged(CGFloat)
        case setPrevPosition(CGFloat)
    }
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
                
            case .posChanged(let positionX):
                state.pos  = positionX
                return .none
            case .setPrevPosition(let prev):
                state.prev = prev
                return .none
            }
        }
    }
}

struct MatchDetailResketchView: View {
    
    var store: StoreOf<MatchDetailResketchDomain>
    @Environment(\.dismiss) var dismiss

    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            GeometryReader { geo in
                ZStack {
                    
                    Color("Black", bundle: .main)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 10) {
                        
//                        HStack {
//                            Text("MATCH DETAILS")
//                                .multilineTextAlignment(.center)
//                                .foregroundStyle(.white)
//                                .font(.gilroy(.bold, size: 18))
//                                .frame(width: geo.size.width, alignment: .center)
//                        }
//                        .overlay {
//                            HStack {
//                                Button {
//                                    dismiss()
//                                } label: {
//                                    Image("Arrow", bundle: .main)
//                                        .resizable()
//                                        .renderingMode(.template)
//                                        .foregroundStyle(.white)
//                                        .rotationEffect(.degrees(180))
//                                        .frame(width: 30, height: 25)
//                                }
//                                
//                                Spacer()
//                            }
//                            .padding(.leading, 20)
//                        }
//                        .padding(.vertical, 15)
                        
                        HeaderView(width: geo.size.width, header: "Match Details")
                        
                        
                        ScrollView(.vertical) {
                            
                            Text("You can use sideways to get better view of the team")
                                .multilineTextAlignment(.center)
                                .font(.gilroy(.regular, size: 15))
                                .frame(width: 240, height: 40)
                                .foregroundStyle(.gray)
                            
                            HStack {
                                
                                if viewStore.match.opponents.count >= 1 {
                                    let firstLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents.first!.opponent.name)
                                    VStack(alignment: .center) {
                                        if firstLiquiTeam != nil {
                                            if firstLiquiTeam!.hasTeamImage {
                                                AsyncImage(url: URL(string: "https://liquipedia.net/\(firstLiquiTeam!.imageURL)")) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                } placeholder: {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Gray2", bundle: .main))
                                                }
                                            } else {
                                                if viewStore.match.opponents.first!.opponent.image_url != nil {
                                                    AsyncImage(url: URL(string: viewStore.match.opponents.first!.opponent.image_url!)) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 80, height: 80)
                                                    } placeholder: {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))
                                                    }
                                                } else {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))                                                            
                                                            .overlay(alignment: .center) {
                                                                Text("?")
                                                                    .foregroundStyle(.white)
                                                                    .font(.gilroy(.medium, size: 30))
                                                            }
                                                    }
                                                    .frame(width: 100, height: 100)
                                                }
                                            }
                                        } else {
                                            if viewStore.match.opponents.first!.opponent.image_url != nil {
                                                AsyncImage(url: URL(string: viewStore.match.opponents.first!.opponent.image_url!)) { image in
                                                    image
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 80, height: 80)
                                                } placeholder: {
                                                    Circle()
                                                        .frame(width: 80, height: 80)
                                                        .foregroundStyle(Color("Gray2", bundle: .main))
                                                }
                                            } else {
                                                VStack {
                                                    VStack {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))
                                                            .overlay(alignment: .center) {
                                                                Text("?")
                                                                    .foregroundStyle(.white)
                                                                    .font(.gilroy(.medium, size: 30))
                                                            }
                                                    }
                                                    .frame(width: 80, height: 80)
                                                    
                                                    Text("TBD")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.bold, size: 17))
                                                }
                                            }
                                        }
                                        
                                        Text(firstLiquiTeam == nil ? viewStore.match.opponents.first!.opponent.name : firstLiquiTeam!.name.teamFormatterName())
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.bold, size: 14))
                                            .frame(width: 130, height: 40)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 150, height: 120, alignment: .center)
                                    
                                    if viewStore.isStarted {
                                        
                                        HStack {
                                            Text("\(viewStore.match.calcScore(of: viewStore.match.opponents.first!.opponent))")
                                            Text(":")
                                            Text("\(viewStore.match.calcScore(of: viewStore.match.opponents[1].opponent))")
                                        }
                                        .foregroundStyle(.gray)
                                        .font(.gilroy(.medium, size: 14))
                                        .frame(width: 60)
                                        
                                    } else if viewStore.match.isMatchFinished() {
                                        
                                        HStack {
                                            Text("\(viewStore.match.calcScore(of: viewStore.match.opponents.first!.opponent))")
                                            Text(":")
                                            Text("\(viewStore.match.calcScore(of: viewStore.match.opponents[1].opponent))")
                                        }
                                        .foregroundStyle(.gray)
                                        .font(.gilroy(.medium, size: 14))
                                        .frame(width: 60)
                                        
                                    } else {
                                        Text("VS")
                                            .foregroundStyle(.gray)
                                            .font(.gilroy(.bold, size: 14))
                                            .frame(width: 60)
                                    }
                                    
                                    if viewStore.match.opponents.indices.contains(1) {
                                        let secondLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents[1].opponent.name)
                                        
                                        VStack(alignment: .center) {
                                            if secondLiquiTeam != nil {
                                                if secondLiquiTeam!.hasTeamImage {
                                                    AsyncImage(url: URL(string: "https://liquipedia.net/\(secondLiquiTeam!.imageURL)")) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 80, height: 80)
                                                    } placeholder: {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))
                                                    }
                                                } else {
                                                    if viewStore.match.opponents[1].opponent.image_url != nil {
                                                        AsyncImage(url: URL(string: viewStore.match.opponents[1].opponent.image_url!)) { image in
                                                            image
                                                                .resizable()
                                                                .scaledToFit()
                                                                .frame(width: 80, height: 80)
                                                        } placeholder: {
                                                            Circle()
                                                                .frame(width: 80, height: 80)
                                                                .foregroundStyle(Color("Gray2", bundle: .main))
                                                        }
                                                    } else {
                                                        VStack(alignment: .center) {
                                                            Circle()
                                                                .frame(width: 80, height: 80)
                                                                .foregroundStyle(Color("Gray2", bundle: .main))
                                                                .overlay(alignment: .center) {
                                                                    Text("?")
                                                                        .foregroundStyle(.white)
                                                                        .font(.gilroy(.medium, size: 30))
                                                                }
                                                        }
                                                        .frame(width: 100, height: 80)
                                                    }
                                                }
                                            } else {
                                                if viewStore.match.opponents[1].opponent.image_url != nil {
                                                    AsyncImage(url: URL(string: viewStore.match.opponents[1].opponent.image_url!)) { image in
                                                        image
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 80, height: 80)
                                                    } placeholder: {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))
                                                    }
                                                } else {
                                                    VStack(alignment: .center) {
                                                        Circle()
                                                            .frame(width: 80, height: 80)
                                                            .foregroundStyle(Color("Gray2", bundle: .main))
                                                            .overlay(alignment: .center) {
                                                                Text("?")
                                                                    .foregroundStyle(.white)
                                                                    .font(.gilroy(.medium, size: 30))
                                                            }
                                                    }
                                                    .frame(width: 150, height: 90, alignment: .center)
                                                    .padding(0)
                                                }
                                            }
                                            
                                            Text(secondLiquiTeam == nil ? viewStore.match.opponents[1].opponent.name : secondLiquiTeam!.name.teamFormatterName())
                                                .textCase(.uppercase)
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 14))
                                                .frame(width: 130, height: 40)
                                                .multilineTextAlignment(.center)
                                        }
                                        .frame(width: 150, height: 120, alignment: .center)

                                    } else {
                                        //IF DIDN'T FIND SECOND OPPONENT
                                        VStack(alignment: .center, spacing: 16) {
                                            VStack {
                                                Circle()
                                                    .frame(width: 80, height: 80)
                                                    .foregroundStyle(Color("Gray2", bundle: .main))
                                                    .overlay(alignment: .center) {
                                                        Text("?")
                                                            .foregroundStyle(.white)
                                                            .font(.gilroy(.medium, size: 30))
                                                    }
                                            }
                                            
                                            Text("TBD")
                                                .textCase(.uppercase)
                                                .foregroundStyle(.white)
                                                .font(.gilroy(.bold, size: 12))
                                        }
                                        .frame(width: 150, height: 100, alignment: .center)
                                        .padding(.bottom, 10)
                                        
                                    }
                                    
                                } else {
                                    //IF HAVEN'T GOT INFO YET
                                    VStack(alignment: .center, spacing: 16) {
                                        VStack {
                                            Circle()
                                                .frame(width: 80, height: 80)
                                                .foregroundStyle(Color("Gray2", bundle: .main))
                                                .overlay(alignment: .center) {
                                                    Text("?")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 30))
                                                }
                                        }
                                        
                                        Text("TBD")
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.bold, size: 12))
                                    }
                                    .frame(width: 150, height: 100, alignment: .center)
                                    .padding(.bottom, 10)
                                    
                                    
                                    Text("VS")
                                        .foregroundStyle(.gray)
                                        .font(.gilroy(.bold, size: 17))
                                        .frame(width: 60)
                                    
                                    
                                    VStack(alignment: .center, spacing: 16) {
                                        VStack {
                                            Circle()
                                                .frame(width: 80, height: 80)
                                                .foregroundStyle(Color("Gray2", bundle: .main))
                                                .overlay(alignment: .center) {
                                                    Text("?")
                                                        .foregroundStyle(.white)
                                                        .font(.gilroy(.medium, size: 30))
                                                }
                                        }
                                        
                                        Text("TBD")
                                            .textCase(.uppercase)
                                            .foregroundStyle(.white)
                                            .font(.gilroy(.bold, size: 12))
                                    }
                                    .frame(width: 150, height: 100, alignment: .center)
                                }
                            }
                            .padding(.vertical, 20)
                            
                            HStack {
                                VStack(spacing: 20) {
                                    if viewStore.match.opponents.count >= 1 {
                                        let firstLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents.first!.opponent.name)
                                        
                                        
                                        ForEach(firstLiquiTeam!.players.filter({ $0.nickname != ""}), id: \.self) { player in
                                            PlayerViewResketch(store: Store(initialState: PlayerViewResketchDomain.State(
                                                rotated: true,
                                                liquiPlayer: player
                                            ), reducer: {
                                                PlayerViewResketchDomain()
                                            }))
                                        }
                                    } else {
                                        ForEach(0..<5, id: \.self) { _ in
                                            PlayerEmptyView(rotated: true)
                                        }
                                    }
                                }
                                .frame(width: geo.size.width * 0.2)
                                .offset(x: -40)
                                
                                Spacer()
                                
                                VStack(spacing: 20) {
                                    if viewStore.match.opponents.indices.contains(1) {
                                        let secondLiquiTeam = viewStore.liquiTeams.getLiquiTeam(by: viewStore.match.opponents[1].opponent.name)
                                        
                                        ForEach(secondLiquiTeam!.players.filter({ $0.nickname != ""}), id: \.self) { player in
                                            PlayerViewResketch(store: Store(initialState: PlayerViewResketchDomain.State(
                                                rotated: false,
                                                liquiPlayer: player
                                            ), reducer: {
                                                PlayerViewResketchDomain()
                                            }))
                                        }
                                    } else {
                                        ForEach(0..<5, id: \.self) { _ in
                                            PlayerEmptyView(rotated: false)
                                        }
                                    }
                                }
                                .frame(width: geo.size.width * 0.2)
                                .offset(x: 40)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .gesture(DragGesture(coordinateSpace: .global).onChanged({ value in

                                let offsetX = value.translation.width

                                let minX = min(197, offsetX + viewStore.prev)
                                let maxX = max(minX, -197)

                                self.store.send(.posChanged(maxX))
                                
                            }).onEnded({ value in
                                
                                let offsetX = value.translation.width
                                
                                let minX = min(197, offsetX + viewStore.prev)
                                let maxX = max(minX, -197)
                                
                                self.store.send(.posChanged(maxX))
                                self.store.send(.setPrevPosition(viewStore.pos ))

                                
                            }))
                            .offset(x: viewStore.pos )
                            if viewStore.isStarted {
                                VStack(spacing: 15) {
                                    HStack {
                                        Text("Twich Stream List")
                                            .font(.gilroy(.bold, size: 17))
                                            .foregroundStyle(.white)
                                    }
                                    
                                    ForEach(viewStore.match.streams_list, id: \.self) { stream in
                                        
                                        HStack(spacing: 0){
                                            Image("Twitch", bundle: .main)
                                            
                                            Text(stream.language.uppercased())
                                                .font(.gilroy(.bold, size: 15))
                                                .foregroundStyle(.white)
                                                .offset(x: -10)
                                            
                                            Spacer()
                                            
                                            Link(destination: URL(string: stream.raw_url)!) {
                                                Image("Arrow", bundle: .main)
                                                    .resizable()
                                                    .renderingMode(.template)
                                                    .foregroundStyle(.white)
                                                    .frame(width: 20, height: 20)
                                            }
                                            
//                                            Button {
//                                                
//                                            } label: {
//                                                Image("Arrow", bundle: .main)
//                                                    .resizable()
//                                                    .renderingMode(.template)
//                                                    .foregroundStyle(.white)
//                                                    .frame(width: 20, height: 20)
//                                            }
                                        }
                                        .offset(x: -14)
                                        .frame(width: geo.size.width * 0.95)
                                        .background {
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundStyle(Color("Gray", bundle: .main))
                                        }
                                    }
                                }
                                .padding(.top, 15)
                            }
                        }
                        .scrollIndicators(.never)
                        
                        
                        
                        
                    }
                    

                }
            }
        }

    }
}

//#Preview {
//    MatchDetailResketchView(store: Store(initialState: MatchDetailResketchDomain.State(isLive: true), reducer: {
//        MatchDetailResketchDomain()
//    }))
//}
