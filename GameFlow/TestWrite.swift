//
//  TestWrite.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 10/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct TestWriteDomain: Reducer {
    
    struct State: Equatable {
        var series: [PandascoreSerie] = []
        
    }
    
    enum Action {
        case checkStamp
        case fetchSeriesPanda(TaskResult<[PandascoreSerie]>)
        case fetchSeriesFireStore(TaskResult<[PandascoreSerie]>)
        
    }
    
    @Dependency(\.apiClient) var apiClient
//    var firestoreManager = FirestoreManager()
    
    var body: some Reducer<State, Action> {
        
        Reduce { state, action in
            switch action {
//            case .fetchSeriesFireStore(.success(let series)):
//                state.series = series
//                return .none
//                
//            case .fetchSeriesFireStore(.failure(let error)):
//                print("FireStore error - ", error)
//                return .none
//                
//            case .fetchSeriesPanda(.failure(let error)):
//                print("Alamogire error - ", error)
//                return .none
//                
//            case .fetchSeriesPanda(.success(let series)):
//                state.series = series
//                return .run {[series = state.series] send in
//                    await firestoreManager.writeData(series: series)
//                }
//            case .checkStamp:
//                return .run { send in
//                    if await firestoreManager.shouldPandascoreReq() {
//                        await send(.fetchSeriesPanda( TaskResult { try await apiClient.fetchUpcomingSeries() }))
//                    } else {
//                        await send(.fetchSeriesFireStore( TaskResult { try await firestoreManager.getData() }))
//                    }
//                }
            default: return .none
            }
        }
    }
}
struct TestWrite: View {
    
    var store: StoreOf<TestWriteDomain>
    
    @State var championShip : ChampionShip? = ChampionShip(series: [])
    var pandascoreManager = PandascoreManager()
    var firestoreManager = FirestoreManager()
    
    
    var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            VStack {
                ScrollView(.vertical) {
                    if championShip != nil {
                        ForEach(championShip!.series, id: \.self) { serie in
                            ForEach(serie.tournaments, id: \.self) { tournament in
                                VStack {
                                    Text("Standings")
                                    Text(String(describing: tournament.standings?.count ?? nil))
                                    
                                }
                                VStack {
                                    Text("Teams")
                                    Text(String(describing: tournament.teams?.count ?? 0))
                                }
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                }
            }
            .task {
                
//                if await self.firestoreManager.shouldPandascoreReq() {
                    
//                    championShip = try? await pandascoreManager.getAllData()
//                    
//                    if championShip != nil {
//                        
//                        for serie in championShip!.series {
//                            print(serie.tournaments.count)
//                        }
////                        firestoreManager.wr
//                    }
                    
                
                
                
                //MARK: - use this to fetch all data needed from pandascore
                    
                do {
//                    championShip = try await pandascoreManager.getAllData() 
//                    if let championShip = championShip {
//                    try await firestoreManager.writeData(championShip: championShip)
//                    }
                    
                    
//                    championShip = try await self.firestoreManager.getData()
                    
                    
//                    let series = try await self.firestoreManager.getSeries()
//                    print(series)
                } catch {
                    
                    print(error)
                }
                
//                    print(championShip?.series.count)
                    
//                }
                
//                self.store.send(.checkStamp)
                
                
                
//                do {
//                     let series = try await pandascoreManager.getSeries()
//                    
//                    for index in series.indices {
//                        championShip.series.append(FireStoreSerie(serie: series[index], tournaments: []))
//                    }
//                    
//                    print(championShip.series.count)
//                } catch {
//                    
//                }
            }
        }
    }
}

#Preview {
    TestWrite(store: Store(initialState: TestWriteDomain.State(), reducer: {
        TestWriteDomain()
    }))
}
