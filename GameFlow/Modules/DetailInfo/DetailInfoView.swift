//
//  DetailInfoView.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 14/10/2023.
//

import SwiftUI
import ComposableArchitecture

struct DetailInfoDomain: Reducer {
    
    struct State: Equatable {
        let serie: Serie
        var tournaments: [Tournament] = []
        let id: UUID
        var filteredTeams: [Team] {
            var teams: [Team] = []
            for tournament in tournaments {
                for team in tournament.teams {
                    if !teams.contains(team) {
                        teams.append(team)
                    }
                }
            }
            return teams
        }
        var upcomingMatches: [Match] {
            
            var upcomingMatches: [Match] = []
            var matchesWithOutDefinedDate: [Match] = []
            let dateFormatter = ISO8601DateFormatter()
            
            for tournament in tournaments {
                for match in tournament.matches {
                    if let matchDate = match.begin_at {
                        let matchStart = dateFormatter.date(from: matchDate)!
                        let currentDate = Date()
                        let nextSevenDays = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
//                        if date.timeIntervalSinceNow.sign == .plus {
//                            upcomingMatches.append(match)
//                        }
                        if matchStart.isBetween(currentDate, and: nextSevenDays) {
                            upcomingMatches.append(match)
                        }
                    } else {
                        matchesWithOutDefinedDate.append(match)
                    }
                }
            }
            upcomingMatches.sort(by: { dateFormatter.date(from: $0.begin_at!)! < dateFormatter.date(from: $1.begin_at!)! })
//            upcomingMatches.append(contentsOf: matchesWithOutDefinedDate)
            print("got \(upcomingMatches.count) matches")
            return upcomingMatches
        }
        
        var teams: [Team] = []
        
    }
    
    
    
    
    
    enum Action {
        case fetchTournaments
        case fetchTournamentsRespons(TaskResult<[Tournament]>)
    }
    
    @Dependency(\.apiClient) var apiClient
    
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchTournaments:
                return .run { [serie = state.serie] send in
                    await send(.fetchTournamentsRespons(TaskResult { try await apiClient.fetchSeriesTournaments(serie) }))
                }
            case .fetchTournamentsRespons(.success(let tournaments)):
                state.tournaments = tournaments
//                print(tournaments)
                return .none
            case .fetchTournamentsRespons(.failure(let error)):
                print(error)
                return .none
            }
        }
    }
}

struct DetailInfoView: View {
    
    var store: StoreOf<DetailInfoDomain>
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            
            ZStack {
                
                Color.mainBack
                    .ignoresSafeArea()
                
                ScrollView {
                    
                    //MARK: - Schedule of Matches
                    VStack(alignment: .leading) {
                        Text("Next matches")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                    
                        
//                        HStack {
//                            ScrollView(.horizontal) {
//                                ForEach(viewStore.upcomingMatches, id: \.self) { match in
//                                    VStack(alignment: .center, spacing: 5) {
//                                        Text(match.getTournamentNameFrom(tournaments: viewStore.tournaments))
//                                            .foregroundStyle(.white)
//                                            .font(.callout)
//                                            .bold()
//                                        
//                                        HStack {
//                                            //                                            Text(match.begin_at!.fotmattedString)
//                                            
//                                            
////                                            AsyncImage(url: URL(string: )) { phase in
////                                                if let image = phase.image {
////                                                    VStack(spacing: 12) {
////
////                                                        image
////                                                            .resizable()
////                                                            .scaledToFill()
////                                                            .frame(width: 40, height: 40)
////                                                            .padding(.horizontal, 10)
////                                                        Text(viewStore.teams[0].acronym ?? "??")
////                                                            .foregroundStyle(.white)
////                                                            .bold()
////                                                            .font(.system(size: 15))
////                                                    }
////                                                }
////                                            }
//                                        }
//                                        
//                                    }
//                                }
//                                    
//                                
//                                
//                                
//                                VStack(alignment: .center, spacing: 5) {
//                                    Text("Main Event")
//                                        .foregroundStyle(.white)
//                                        .font(.callout)
//                                        .bold()
//                                    
//                                    HStack {
//                                        Text("Oct 21 * 19:00 CEST")
//                                            .foregroundStyle(.gameListCellForeground)
//                                            .font(.footnote)
//                                    }
//                                    HStack() {
////                                        AsyncImage(url: URL(string: viewStore.teams[0].image_url ?? "")) { phase in
////                                            if let image = phase.image {
////                                                VStack(spacing: 12) {
//////                                                    Circle()
//////                                                        .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
//////                                                        .frame(width: 30, height: 30)
//////                                                        .overlay(content: {
//////                                                            Circle()
//////                                                                .stroke(lineWidth: 1)
//////                                                                .foregroundStyle(.white)
//////                                                                .frame(width: 30, height: 30)
//////                                                        })
//////                                                        .overlay {
////                                                            image
////                                                                .resizable()
////                                                                .scaledToFill()
////                                                                .frame(width: 40, height: 40)
////                                                                .padding(.horizontal, 10)
//////                                                        }
////                                                    Text(viewStore.teams[0].acronym ?? "??")
////                                                        .foregroundStyle(.white)
////                                                        .bold()
////                                                        .font(.system(size: 15))
////                                                }
////                                            }
////                                        }
////                                        Text("-")
////                                            .offset(y: -10)
////                                        AsyncImage(url: URL(string: viewStore.teams[0].image_url ?? "")) { phase in
////                                            if let image = phase.image {
////                                                VStack(spacing: 12) {
//////                                                    Circle()
//////                                                        .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
//////                                                        .frame(width: 30, height: 30)
//////                                                        .overlay(content: {
//////                                                            Circle()
//////                                                                .stroke(lineWidth: 1)
//////                                                                .foregroundStyle(.white)
//////                                                                .frame(width: 30, height: 30)
//////                                                        })
//////                                                        .overlay {
////                                                            image
////                                                                .resizable()
////                                                                .scaledToFill()
////                                                                .frame(width: 40, height: 40)
////                                                                .padding(.horizontal, 10)
//////                                                        }
////                                                    Text(viewStore.teams[0].acronym ?? "??")
////                                                        .foregroundStyle(.white)
////                                                        .bold()
////                                                        .font(.system(size: 15))
////                                                }
////                                            }
////                                        }
////                                        AsyncImage(url: URL(string: viewStore.teams[0].image_url ?? "")) { phase in
////                                            if let image = phase.image {
////                                                HStack {
////                                                    Circle()
////                                                        .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
////                                                        .frame(width: 30, height: 30)
////                                                        .overlay(content: {
////                                                            Circle()
////                                                                .stroke(lineWidth: 1)
////                                                                .foregroundStyle(.white)
////                                                                .frame(width: 30, height: 30)
////                                                        })
////                                                        .overlay {
////                                                            image
////                                                                .resizable()
////                                                                .scaledToFill()
////                                                                .frame(width: 20, height: 20)
////                                                                .padding(.horizontal, 10)
////                                                        }
////                                                    Text(viewStore.teams[0].acronym ?? "??")
////                                                        .foregroundStyle(.white)
////                                                        .bold()
////                                                        .font(.system(size: 15))
////                                                }
////                                            }
////                                        }
//                                    }
//                                    .padding(.top)
//                                    
//                                }
//                                .padding()
////                                .padding(.bottom)
//                                .padding(.horizontal, 7)
//                                .background(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
//                                        .overlay(content: {
//                                            RoundedRectangle(cornerRadius: 10)
//                                                .stroke(lineWidth: 1)
//                                                .foregroundStyle(.white)
//                                        })
//                                )
//                                .padding(.horizontal)
//                            }
//                            .scrollIndicators(.hidden)
//                        }
                        
                            UpcomingMatchesList(store: Store(initialState: UpcomingMatchesListDomain.State(tournaments: viewStore.tournaments), reducer: {
                                UpcomingMatchesListDomain()
                            }))
                    }
                    
                    
                    
                    //MARK: - Tournament's Results
                    VStack(alignment: .leading) {
                        Text("Results")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                            .padding(.bottom, 10)
                            .padding(.horizontal)
                        
                            ResultsList(store: Store(initialState: ResultsListDomain.State(tournaments: viewStore.tournaments), reducer: {
                                ResultsListDomain()
                            }))
                        
                        
                        //                        HStack() {
                        //                            HStack {
                        //                                //TODO: - if not finished than this one, then next TODO
                        //                                Image(systemName: "clock")
                        //                                    .font(.system(size: 25))
                        //                                    .foregroundStyle(.white)
                        //                                    .padding(.horizontal)
                        //                                    .background(
                        //                                        Circle()
                        //                                            .foregroundStyle(.gray)
                        //                                            .frame(width: 50, height: 50)
                        //
                        //                                    )
                        //                                //                                .padding(.horizontal)
                        //                                //TODO: - this one
                        //                                //                            Image(systemName: "checkmark")
                        //                                //                                .font(.system(size: 19))
                        //                                //                                .foregroundStyle(.white)
                        //                                //                                .background(
                        //                                //                                    Circle()
                        //                                //                                        .foregroundStyle(.gray)
                        //                                //                                        .frame(width: 40, height: 40)
                        //                                //
                        //                                //                                )
                        //
                        //                                VStack(alignment: .leading) {
                        //                                    Text("Group")
                        //                                        .foregroundStyle(.white)
                        //                                        .font(.system(size: 19))
                        //                                        .bold()
                        //                                    HStack {
                        //                                        Text("Upcoming ·")
                        //                                        Text("Date: TBD")
                        //
                        //                                    }
                        //                                    .font(.system(size: 15))
                        //                                    .foregroundStyle(.gameListCellForeground)
                        //
                        //                                }
                        //                            }
                        //
                        //                            Spacer()
                        //
                        //                            Button {
                        //
                        //                            } label: {
                        //                                Image("Arrow", bundle: .main)
                        //                                    .resizable()
                        //                                    .renderingMode(.template)
                        //                                    .foregroundStyle(.white)
                        //                                    .frame(width: 20, height: 20)
                        //                                    .rotationEffect(.degrees(90))
                        //                                    .padding(.trailing, 10)
                        //                            }
                        //                        }
                        //                        .padding(.bottom, 15)
                        //                        HStack() {
                        //                            HStack {
                        //                                //TODO: - if not finished than this one, then next TODO
                        //                                Image(systemName: "clock")
                        //                                    .font(.system(size: 25))
                        //                                    .foregroundStyle(.white)
                        //                                    .padding(.horizontal)
                        //                                    .background(
                        //                                        Circle()
                        //                                            .foregroundStyle(.gray)
                        //                                            .frame(width: 50, height: 50)
                        //
                        //                                    )
                        //                                //                                .padding(.horizontal)
                        //                                //TODO: - this one
                        //                                //                            Image(systemName: "checkmark")
                        //                                //                                .font(.system(size: 19))
                        //                                //                                .foregroundStyle(.white)
                        //                                //                                .background(
                        //                                //                                    Circle()
                        //                                //                                        .foregroundStyle(.gray)
                        //                                //                                        .frame(width: 40, height: 40)
                        //                                //
                        //                                //                                )
                        //
                        //                                VStack(alignment: .leading) {
                        //                                    Text("Group")
                        //                                        .foregroundStyle(.white)
                        //                                        .font(.system(size: 19))
                        //                                        .bold()
                        //                                    HStack {
                        //                                        Text("Upcoming ·")
                        //                                        Text("Date: TBD")
                        //
                        //                                    }
                        //                                    .font(.system(size: 15))
                        //                                    .foregroundStyle(.gameListCellForeground)
                        //
                        //                                }
                        //                            }
                        //
                        //                            Spacer()
                        //
                        //                            Button {
                        //
                        //                            } label: {
                        //                                Image("Arrow", bundle: .main)
                        //                                    .resizable()
                        //                                    .renderingMode(.template)
                        //                                    .foregroundStyle(.white)
                        //                                    .frame(width: 20, height: 20)
                        //                                    .rotationEffect(.degrees(90))
                        //                                    .padding(.trailing, 10)
                        //                            }
                        //                        }
                        //                        .padding(.bottom, 15)
                        //                        HStack() {
                        //                            HStack {
                        //                                //TODO: - if not finished than this one, then next TODO
                        //                                Image(systemName: "clock")
                        //                                    .font(.system(size: 25))
                        //                                    .foregroundStyle(.white)
                        //                                    .padding(.horizontal)
                        //                                    .background(
                        //                                        Circle()
                        //                                            .foregroundStyle(.gray)
                        //                                            .frame(width: 50, height: 50)
                        //
                        //                                    )
                        //                                //                                .padding(.horizontal)
                        //                                //TODO: - this one
                        //                                //                            Image(systemName: "checkmark")
                        //                                //                                .font(.system(size: 19))
                        //                                //                                .foregroundStyle(.white)
                        //                                //                                .background(
                        //                                //                                    Circle()
                        //                                //                                        .foregroundStyle(.gray)
                        //                                //                                        .frame(width: 40, height: 40)
                        //                                //
                        //                                //                                )
                        //
                        //                                VStack(alignment: .leading) {
                        //                                    Text("Group")
                        //                                        .foregroundStyle(.white)
                        //                                        .font(.system(size: 19))
                        //                                        .bold()
                        //                                    HStack {
                        //                                        Text("Upcoming ·")
                        //                                        Text("Date: TBD")
                        //
                        //                                    }
                        //                                    .font(.system(size: 15))
                        //                                    .foregroundStyle(.gameListCellForeground)
                        //
                        //                                }
                        //                            }
                        //
                        //                            Spacer()
                        //
                        //                            Button {
                        //
                        //                            } label: {
                        //                                Image("Arrow", bundle: .main)
                        //                                    .resizable()
                        //                                    .renderingMode(.template)
                        //                                    .foregroundStyle(.white)
                        //                                    .frame(width: 20, height: 20)
                        //                                    .rotationEffect(.degrees(90))
                        //                                    .padding(.trailing, 10)
                        //                            }
                        //                        }
                        ////                        HStack() {
                        ////                            HStack {
                        ////                                //TODO: - if not finished than this one, then next TODO
                        ////                                Image(systemName: "clock")
                        ////                                    .font(.system(size: 19))
                        ////                                    .foregroundStyle(.white)
                        ////                                    .padding(.horizontal)
                        ////                                    .background(
                        ////                                        Circle()
                        ////                                            .foregroundStyle(.gray)
                        ////                                            .frame(width: 40, height: 40)
                        ////
                        ////                                    )
                        ////                                //                                .padding(.horizontal)
                        ////                                //TODO: - this one
                        ////                                //                            Image(systemName: "checkmark")
                        ////                                //                                .font(.system(size: 19))
                        ////                                //                                .foregroundStyle(.white)
                        ////                                //                                .background(
                        ////                                //                                    Circle()
                        ////                                //                                        .foregroundStyle(.gray)
                        ////                                //                                        .frame(width: 40, height: 40)
                        ////                                //
                        ////                                //                                )
                        ////
                        ////                                VStack(alignment: .leading) {
                        ////                                    Text("Group")
                        ////                                        .foregroundStyle(.white)
                        ////                                        .bold()
                        ////                                    HStack {
                        ////                                        Text("Upcoming ·")
                        ////                                        Text("Date: TBD")
                        ////                                    }
                        ////                                    .foregroundStyle(.gameListCellForeground)
                        ////                                    .font(.footnote)
                        ////                                }
                        ////                            }
                        ////
                        ////                            Spacer()
                        ////
                        ////                            Button {
                        ////
                        ////                            } label: {
                        ////                                Image("Arrow", bundle: .main)
                        ////                                    .resizable()
                        ////                                    .renderingMode(.template)
                        ////                                    .foregroundStyle(.white)
                        ////                                    .frame(width: 20, height: 20)
                        ////                                    .rotationEffect(.degrees(90))
                        ////                                    .padding(.trailing, 10)
                        ////                            }
                        ////                        }
                        //                        .padding(.bottom, 10)
                    }
                    
                    
                    
                    //MARK: - Participants from each group
                    VStack(alignment: .leading) {
                        Text("Participants")
                            .foregroundStyle(.white)
                            .font(.title2)
                            .bold()
                            .padding(.horizontal)
                        
                        HStack {
                            ScrollView(.horizontal) {
                                
                                Button {
                                    
                                } label: {
                                    HStack {
                                        Text("All")
                                            .font(.system(size: 20))
                                        Text("10")
                                            .frame(width: 30)
                                            .padding(.horizontal, 3)
                                            .background(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .foregroundStyle(.white.opacity(0.5))
                                            )
                                    }
                                    
                                    .foregroundStyle(.white)
                                    .padding(10)
                                    .padding(.horizontal, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 25)
                                            .foregroundStyle(.gameListCellForeground)
                                    )
                                }
                                .padding(.horizontal)
                                
                            }
                            .scrollIndicators(.hidden)
                        }
                        .padding(.bottom, 10)
                        
                        ScrollView(.horizontal) {
                            HStack(spacing: 20) {
                                                                ForEach(viewStore.filteredTeams, id: \.self) { team in
//                                ForEach(viewStore.teams, id: \.self) { team in
                                    VStack(spacing: 5) {
                                        
                                        AsyncImage(url: URL(string: team.image_url ?? "")) { phase in
                                            if let image = phase.image {
                                                //                                                image
                                                //                                                    .resizable()
                                                //                                                    .scaledToFill()
                                                //                                                    .frame(width: 30, height: 30)
                                                //                                                    .padding(.horizontal, 10)
                                                //                                                    .background(
                                                //                                                        Circle()
                                                ////                                                            .foregroundStyle(.)
                                                //                                                            .frame(width: 60, height: 60)
                                                //                                                            .overlay(content: {
                                                //                                                                Circle()
                                                //                                                                    .stroke(lineWidth: 1)
                                                //                                                                    .foregroundStyle(.white)
                                                //                                                                    .frame(width: 60, height: 60)
                                                //                                                            })
                                                //                                                    )
                                                Circle()
                                                    .foregroundStyle(Color("DarkBlueBackgorund", bundle: .main))
                                                    .frame(width: 60, height: 60)
                                                    .overlay(content: {
                                                        Circle()
                                                            .stroke(lineWidth: 1)
                                                            .foregroundStyle(.white)
                                                            .frame(width: 60, height: 60)
                                                    })
                                                    .overlay {
                                                        image
                                                            .resizable()
                                                            .scaledToFill()
                                                            .frame(width: 30, height: 30)
                                                            .padding(.horizontal, 10)
                                                    }
                                            }
                                        }
                                        
                                        Text(team.acronym ?? "??")
                                            .bold()
                                            .foregroundStyle(.white)
                                    }
                                    
                                }
                            }
                            .frame(height: 90)
                            .padding(.horizontal)
                        }
                        .scrollIndicators(.hidden)
                        
                    }
                    
                    
                }
                .task {
                    do {
                        try await Task.sleep(for: .seconds(2))
                        await viewStore.send(.fetchTournaments).finish()
                    } catch { }
                }
            }
        }
    }
}

#Preview {
    DetailInfoView(store: Store(initialState: 
//                                    DetailInfoDomain.State(),

                                    DetailInfoDomain.State(
        serie: Serie(
            begin_at: nil,
            end_at: nil,
            full_name: "",
            id: 123,
            league:
                League(
                    id: 123,
                    image_url: nil,
                    modified_at: "",
                    name: "",
                    slug: "",
                    url: nil),
            league_id: 123,
            modified_at: "fasfsd",
            name: nil,
            season: nil,
            slug: "",
            tournaments: [],
            winner_type: nil,
            year: 123), id: .init(), teams: [Team(acronym: "EG", id: 123, image_url: "https://cdn.pandascore.co/images/team/image/1653/152px_evil_geniuses_2020_lightmode.png", location: "US", modified_at: "2023-10-16T06:07:24Z", name: "Evil Geniuses", slug: "evil-geniuses-dota-2"), Team(acronym: "LGD", id: 123, image_url: "https://cdn.pandascore.co/images/team/image/1657/600px_lgd_gaming_december_2019_lightmode.png", location: "CN", modified_at: "2023-10-16T06:07:24Z", name: "LGD Gaming", slug: "evil-geniuses-dota-2")]), reducer: {
        DetailInfoDomain()
        
    }))
}
