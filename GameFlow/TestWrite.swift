//
//  TestWrite.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 10/11/2023.
//

import SwiftUI
import ComposableArchitecture
import SwiftSoup

struct TestWriteDomain: Reducer {
    
    struct State: Equatable {
        var series: [PandascoreSerie] = []
        
    }
    
    enum Action {
        case checkStamp
        case fetchSeriesPanda(TaskResult<[PandascoreSerie]>)
        case fetchSeriesFireStore(TaskResult<[PandascoreSerie]>)
        
    }
    
//    @Dependency(\.apiClient) var apiClient
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
    
//    var store: StoreOf<TestWriteDomain>
    
    
    let apiClient = ApiClient()
//    @State var championShip : ChampionShip = ChampionShip(series: [])
    var pandascoreManager = PandascoreManager()
    var firestoreManager = FirestoreManager()
    var liquiManager = LiqupediaWebScraper()
    @State var pandaSeries: [PandascoreSerie] = []
//    @State var tournamentLink = try? parseHTML()
    @State var liquipediaInfo: [Serie] = []
    @State var liquiSerie = [LiquipediaSerie.LiquipediaTeam]()
    
    
    
    var body: some View {
        ScrollView {
            
        
            VStack {
                Button {
                    
                    print("pressed")
                    
                    do {
//                        try parseHTML(series: championShip.series)
//                        try getTeams()
//                        for serie in pandaSeries {
//                            championShip.series.append(Serie(serie: serie, tournaments: [], liquipeadiaSerie: nil))
//                        }
                        
                        
                        
                        
//                        let series = try await self.apiClient.fetchRelevantSeries()
                         
//                         let filteredSerie = try await self.apiClient.filteredSeries(liquiSeries: liquiSerie, pandaSeries: series)
//                        try await self.apiClient.writeDataToFirestore(filteredSerie)
                        
                        
                        
                        
//                        liquipediaInfo =  try liquiManager.getLiquiData(series: championShip.series)
                         
                    } catch {
                        print(error)
                    }
                    
                } label: {
                    Text("Run SwiftSoup")
                }
                
                ForEach(liquiSerie, id: \.self) { team in
                    VStack {
                        Text(team.name)
                            .bold()
                        
                        ForEach(team.players, id: \.self) { player in
                            HStack {
                                Text(player.nickname)
                                Text(player.position)
                            }
                        }
                    }
                }
 
            }
        }
        .task {
            do {
                
//                let series = try await self.pandascoreManager.getPandaSeries(fetchType: .ongoing)
//                if let serie = series.first {
//                    let serieTournaments = try await self.pandascoreManager.getPandaSerieTournaments(serie)
//                    let serieMatches = try await self.pandascoreManager.setupTournamentsFrom(serie)
//                }
                
//                try await self.apiClient.getFirestoreSeries()
                
                let series = try await self.apiClient.fetchRelevantPandaSeries()
                 let liquiSerie = try await self.apiClient.getRelevantLiquiSeries()
                 let filteredSerie = try await self.apiClient.filteredSeries(liquiSeries: liquiSerie, pandaSeries: series)
                try await self.apiClient.writeDataToFirestore(filteredSerie)
                
                
                
//                liquiSerie = try await getTeams()
                
                
            
                print("successfully loaded data to firestore")
                
//                try await self.pandascoreManager.getPandaSeries(fetchType: .upciming)
//                championShip = try await firestoreManager.getData()
//                pandaSeries = try await self.pandascoreManager.getPandaSeries(fetchType: .ongoing)
//                print(pandaSeries.count)
//                try await liquiManager.getTierLinks()
//                try await liquiManager.getTierLinks()
//                try await liquiManager.getAllTournaments()
//                try await self.pandascoreManager.fetchRelevantSeries()
            } catch {
                print(error )
            }
        }
    }
//    func getTeams() async throws {
//        
////        let tournamentHeader = try element.getElementsByClass("gridCell Tournament Header")
//        
////        try tournamentHeader.select("span").remove()
//        
////        let tournamentLink = try tournamentHeader.select("a")
//        
////        guard let url = URL(string: try tournamentLink.attr("href")) else {
////            throw RequestError.parsigError
////        }
//        
//        let tournDetail = try await liquiManager.parseHTML(url: "https://liquipedia.net/dota2/ESL_One/Kuala_Lumpur/2023/Southeast_Asia/Open_Qualifier/2")
//        
//        let teamsInfo = try tournDetail.getElementsByClass("template-box")
//        
//        for teamInfo in teamsInfo {
//            
//            let teamPartisipants = try teamInfo.getElementsByClass("wikitable wikitable-bordered list")
//            
//            for player in try teamPartisipants.select("tr") {
//                let playerPosition = try player.select("th").text()
////                print("playerPosition -", playerPosition)
//                let playerNickname = try player.select("a").text()
////                print("playerPosition -", playerNickname)
//                let playerCountry = try player.select("img").attr("src")
////                print("player flag -", playerCountry)
//            }
////            print(try teamPartisipants.select("tr").outerHtml())
//            
//
//            let teamLogo = try teamInfo.getElementsByClass("wikitable wikitable-bordered logo")
//            let teamImage = try teamLogo.select("img").attr("src")
//            let teamName = try teamInfo.select("center").text()
////            print(try teamName.text())
////            let team = team
////            print("team logo -", teamImage)
//            
//        }
//        
//        
//    //         try tournamentLink.attr("href")
//        //            let tournamentLink = try tournamentHeader.attr("href")
//        
//    //        print(try tournamentLink.attr("href"))
//        
////        return Serie(serie: serie.serie, tournaments: serie.tournaments, liquipeadiaSerie: LiquipediaSerie(prizepool: serie.liquipediaSerie?.prizepool, teams: nil, tier: serie.liquipediaSerie?.tier))
//        
//    }
}

#Preview {
//    TestWrite(store: Store(initialState: TestWriteDomain.State(), reducer: {
//        TestWriteDomain()
//    }))
    TestWrite()
}




//func parseHTML(series: [Serie]) throws -> String {
//    
//    guard let url = URL(string: "https://liquipedia.net/dota2/Portal:Tournaments") else {
//        print("error")
//        return "FailedURL"
//    }
//    
//    let htmlString = try String(contentsOf: url)
//    
//    let document: Document = try SwiftSoup.parse(htmlString)
//    
////    let body = document.body()
//    
//    let grids = try document.getElementsByClass("gridTable tournamentCard NoGameIcon")
//    
//    for grid in grids {
//        
//        let liquiTournaments = try grid.getElementsByClass("gridRow")
//        
//        for liquiTournament in liquiTournaments {
//            
//            let tournamentHeader = try liquiTournament.getElementsByClass("gridCell Tournament Header")
//            
//            var tournamentsName = try tournamentHeader.text()
//            let sameTourn = sameTournamentsOnLiq(series, tournamentName: tournamentsName)
//            
//            let tournamentPrizepool = try liquiTournament.getElementsByClass("gridCell EventDetails Prize Header")
//            
////            let tournWithLiqPrizeppol = getTournamentPrizepoolFor(series: sameTourn, prizepool: try tournamentPrizepool.text())
//            
//            
////            let tournamentTier = try tournament.getElementsByClass("gridCell Tier Header")
//            
//            
////            for serie in series {
////                
////                tournamentsName = tournamentsName.replacingOccurrences(of: "#", with: "")
////                tournamentsName = tournamentsName.replacingOccurrences(of: ":", with: "")
////                tournamentsName = tournamentsName.replacingOccurrences(of: " ", with: "")
////                
////                tournamentsName = tournamentsName.uppercased()
////                tournamentsName = String(tournamentsName.sorted())
////                
////                
////                
////                var fireStoreTournament = serie.fullName
//////                var fireStoreTournament = "ESL One Kuala Lumpur Western Europe Open Qualifier 1 2023"
////                fireStoreTournament = fireStoreTournament.replacingOccurrences(of: " ", with: "")
////                fireStoreTournament = fireStoreTournament.uppercased()
////                
////                fireStoreTournament = String(fireStoreTournament.sorted())
////                
//////                print("Firestore tournament -", fireStoreTournament.uppercased())
////                let difference = zip(tournamentsName, fireStoreTournament).filter{$0 != $1}
////                
////                if difference.count == 0 {
////                    print("match")
////                    print(serie.serie.id)
////                } else {
////                    fireStoreTournament = serie.fullName
////                    fireStoreTournament = fireStoreTournament.replacingOccurrences(of: "2023", with: "")
////                    fireStoreTournament = fireStoreTournament.replacingOccurrences(of: " ", with: "")
////                    fireStoreTournament = fireStoreTournament.uppercased()
////                    fireStoreTournament = String(fireStoreTournament.sorted())
////                    
////                    let difference = zip(tournamentsName, fireStoreTournament).filter{$0 != $1}
////                    if difference.count <= 2 {
////                        print("New match")
////                        print(serie.serie.id)
////                    }
////                }
////            }
//            
////            EPL World Series: America Season 8
////            EPL World Series America season 8 2023
//
//            
////            if tournamentsName == fireStoreTournament {
////                print("match")
////            } else {
////                
////                
////                
////                print("difference -", difference)
////            }
//            
////            if let serie = championChip.series.first(where: { String($0.fullName.replacingOccurrences(of: " ", with: "").sorted()) == String(tournamentsName.replacingOccurrences(of: " ", with: "").sorted()) }) {
////                
////                print("match")
////            } else {
////                print("no match")
////
////                print(String(tournamentsName.sorted()))
////                print(tournamentsName)
////            }
//
//            
//            
//            
//            try tournamentHeader.select("span").remove()
//            
////            let tournamentLink = try tournamentHeader.attr("href")
//            
//            var tournamentLink = try tournamentHeader.select("a")
//            
//            print(try tournamentLink.attr("href"))
//            
////            print(try tournamentHeader.outerHtml())
//            
////            print(try tournamentLink.outerHtml())
////            print(try tournamentLink)
//            
//            
////            let tournamentLink = try tournamentName.attr("href")
////            let tournamentLinks = try tournamentName.select("a")
//            
////            try tournamentLinks.select("span").remove()
//            
////            if tournamentLinks.array().count == 2 {
////                
////                
////                
////            }
////            try tournamentLinks.removeClass("league-icon-small-image")
////            print("a count -", tournamentLinks.array().count)
//            
////            print(try tournamentLinks.outerHtml())
//            
//            
//            let tournamentDuration = try liquiTournament.getElementsByClass("gridCell EventDetails Date Header")
//            
//            
////            print("name:\(try tournamentName.text()) duration: \(try tournamentDuration.text()) prizepool: \(try tournamentPrizepool.text())")
//        }
//    }
//    
//    return "Finished parsing"
//}

//MARK: - check if there are tournaments that i have in firestore
func sameTournamentsOnLiq(_ series: [Serie], tournamentName: String) -> [Serie] {
    
    var result: [Serie] = []
    
    var tournamentName = tournamentName
    tournamentName = tournamentName.replacingOccurrences(of: "#", with: "")
    tournamentName = tournamentName.replacingOccurrences(of: ":", with: "")
    tournamentName = tournamentName.replacingOccurrences(of: " ", with: "")
    tournamentName = tournamentName.uppercased()
    tournamentName = String(tournamentName.sorted())
    
    for serie in series {
        
        var fireStoreTournament = serie.fullName
        fireStoreTournament = fireStoreTournament.replacingOccurrences(of: " ", with: "")
        fireStoreTournament = fireStoreTournament.uppercased()
        fireStoreTournament = String(fireStoreTournament.sorted())
        
        let difference = zip(tournamentName, fireStoreTournament).filter{$0 != $1}
        
        if difference.count == 0 {
            print("match")
            print(serie.serie.id)
            result.append(serie)
        } else {
            
            fireStoreTournament = serie.fullName
            fireStoreTournament = fireStoreTournament.replacingOccurrences(of: "2023", with: "")
            fireStoreTournament = fireStoreTournament.replacingOccurrences(of: " ", with: "")
            fireStoreTournament = fireStoreTournament.uppercased()
            fireStoreTournament = String(fireStoreTournament.sorted())
            
            let difference = zip(tournamentName, fireStoreTournament).filter{$0 != $1}
            
            if difference.count <= 2 {
                print("New match")
                print(serie.serie.id)
                result.append(serie)
            }
        }
        
    }
    
    return result
    
}



func getTournamentPrizepoolFor( series: [Serie], prizepool: String) -> [Serie] {
    
    for serie in series {
        
    }
    
    return []
    
}

func getTournamentTier() async throws {
    
}

func parseTeams(tournamentURL: String) throws {
    
    
    guard let url = URL(string: tournamentURL) else {
        return
    }
    
    let htmlString = try String(contentsOf: url)
    
    let document = try SwiftSoup.parse(htmlString)
    
    let teams = try document.getElementsByClass("template-box")
    
    for team in teams {
        
        let link = try team.select("a")
        print(link)
        
    }
}
 



private let base = "https://liquipedia.net"


 func getTeamPlayers(teamInfoElement: Element) async throws -> [LiquipediaSerie.LiquipediaPlayer] {
    
    var teamPlayers: [LiquipediaSerie.LiquipediaPlayer] = []
     
//     var teamPartisipants = try teamInfoElement.getElementsByClass("teamcard-inner")
     var teamPartisipants = try teamInfoElement.getElementsByClass("wikitable wikitable-bordered list").filter({ try $0.attr("data-toggle-area-content") == "1" })
     
     print("team part count -", teamPartisipants.count)
//         .filter({ try $0.attr("data-toggle-area-content") != "1"})
//     print(try teamPartisipants.select("data-toggle-area-content"))
//     for element in try 
     for element in teamPartisipants {
//         if try element.attr("data-toggle-area-content") == "1" {
             
             print(try element.attr("data-toggle-area-content"))
//         }
//         print(try element.attr("data-toggle-area-content").filter({ $0 == "1"}))
     }
//     {
//         print(try element.text())
//     }
//     print(try teamPartisipants.html())
     
    
    try await withThrowingTaskGroup(of: LiquipediaSerie.LiquipediaPlayer.self) { taskGroup in
        for player in try teamPartisipants.first!.select("tr").prefix(5) {
            taskGroup.addTask {
                
                
                let playerPosition = try player.select("th").text()
                
                let playerNickname = try player.select("a").text()
                
                let playerCountry = try player.select("img").attr("src")
                
                return LiquipediaSerie.LiquipediaPlayer(nickname: playerNickname, flagURL: playerCountry, position: playerPosition)
            }
        }
        
        for try await result in taskGroup {
            teamPlayers.append(result)
        }
    }
    return teamPlayers
}

 func getTeams() async throws -> [LiquipediaSerie.LiquipediaTeam] {
    
    var liquipediaTeams: [LiquipediaSerie.LiquipediaTeam] = []
     
     
    
//    let tournamentHeader = try liqTourn.getElementsByClass("gridCell Tournament Header")
//    
//    try tournamentHeader.select("span").remove()
//    
//    let tournamentLink = try tournamentHeader.select("a")
//    
//    let tournDetailLink = try await parseHTMLFrom("\(base)\(try tournamentLink.attr("href"))")
    
     let tournDetailLink = try await parseHTMLFrom("https://liquipedia.net/dota2/Pinnacle_25_Year_Anniversary_Show")
    
    
//        let teamsInfo = try tournDetailLink.getElementsByClass("template-box")
    let teamsInfo = try tournDetailLink.getElementsByClass("teamcard toggle-area toggle-area-1")
    
    
    try await withThrowingTaskGroup(of: LiquipediaSerie.LiquipediaTeam.self) { taskGroup in
        for teamInfo in teamsInfo {
            
            taskGroup.addTask {
                
                let teamLogo = try teamInfo.getElementsByClass("wikitable wikitable-bordered logo").select("img").attr("src")
                
                let teamName = try teamInfo.select("center").text()
                
                let players = try await getTeamPlayers(teamInfoElement: teamInfo)
                
                return LiquipediaSerie.LiquipediaTeam(imageURL: teamLogo, name: teamName, players: players)
            }
        }
        
        for try await result in taskGroup {
            liquipediaTeams.append(result)
        }
    }
    
    return liquipediaTeams
}

private func parseHTMLFrom(_ customUrl: String?) async throws -> Document {
    
    guard let url = URL(string: customUrl == nil ? "https://liquipedia.net/dota2/Portal:Tournaments" : customUrl!) else {
        throw WebScrapingError.invalidURL
    }
    
    let urlData = try Data(contentsOf: url)
    let htmlString = String(data: urlData, encoding: .ascii)
    
    let document: Document = try SwiftSoup.parse(htmlString!)

    return document
    
}
