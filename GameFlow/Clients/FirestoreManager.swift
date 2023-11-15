//
//  FirestoreManager.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 10/11/2023.
//

import Foundation
import FirebaseFirestore

///If match starts in 5 min
///If match starts in less than 15 min
///If any match started, than fetch every 30 min

struct FirestoreManager {
    
    private let db = Firestore.firestore()
    
    //MARK: - Function to know whether I need to make Pandascore request or not
    
    private func getLastDateStamp() async -> String? {
        
        let docRef = db.collection("DateStamps").document("LastFetch")
        
        var lastDateStamp: String? = nil
        
        do {
            let document = try await docRef.getDocument()

            if let data = document.data() {
                lastDateStamp = data["DateStamp"] as? String ?? ""
            } else {
                //throw an error
                print("failed with Data")
            }
            
        } catch {
            //Handle errors
            print(error)
        }
        
        print(lastDateStamp as Any)
        return lastDateStamp
    }
    
    func matchesStartin15() async -> Bool {
        return true
    }
    
    func shouldPandascoreReq() async -> Bool {
        
        
        if let lastStamp = await getLastDateStamp() {
            
            
            //DateStamp as Date
            let ISOstampAsDate = lastStamp.ISOfotmattedString()
            
            //user's DateStamp as Date
            let date = Date().iso8601
            let ISOusersDate = date.ISOfotmattedString()
            
            
            
            let calendar = Calendar.current
            
            //Difference between last fetch and current time
            let difference = calendar.dateComponents([.month, .day, .hour, .minute], from: ISOusersDate, to: ISOstampAsDate)
            
            if let hours = difference.hour {
                if hours != 0 {
                    print("The difference is - \(hours) hours")
                    return true
                } else {
                    print("The difference is less than one hour")
                    return false
                }
            } else {
                print("The difference is less than one hour")
                return false
            }
        } else {
            return true
        }
    }
    
    //MARK: - rewrite data to fireStore have to make request to Pandascore
    
    func writeTournamentsStandings(serie: Serie) async throws {

        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    try await writeTournamentStandings(tournament, serie: serie)
                }
            }
        }
    }
    
    func writeTournamentStandings(_ tournament: Tournament, serie: Serie) async throws {
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            
            let docRef = db.collection("ChampionShips")
            
//            print("so writing tournaments standings, its count of each tournament's standings - \(tournament.standings?.count ?? 0)")
            if let standings = tournament.standings {
                for standing in standings {
                    groupTask.addTask {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .collection("Standings")
                            .document("\(standing.rank)")
                            .setData(from: standing.self)
                        
                    }
                }
            }
        }
    }
    
    func writeTournamentsBrackets(serie: Serie) async throws {
        

        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    try await writeTournamentBrackets(tournament, serie: serie)
                }
            }
        }
    }
    
    func writeTournamentBrackets(_ tournament: Tournament, serie: Serie) async throws {
            
        let docRef = db.collection("ChampionShips")
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            if let brackets = tournament.brackets {
                for bracket in brackets {
                    groupTask.addTask {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .collection("Brackets")
                            .document("\(bracket.id)")
                            .setData(from: bracket.self)
                        
                    }
                }
            }
        }
    }
    
    func writeTournamentsMatches(serie: Serie) async throws {
        

        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    try await writeTournamentMatches(tournament, serie: serie)
                }
            }
        }
    }
    
    func writeTournamentMatches(_ tournament: Tournament, serie: Serie) async throws {
        let docRef = db.collection("ChampionShips")
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            if let matches = tournament.matches {
                for match in matches {
                    groupTask.addTask {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .collection("Matches")
                            .document("\(match.id)")
                            .setData(from: match.self)
                        
                    }
                }
            }
        }
    }
    
    func writeTournamentsTeams(serie: Serie) async throws {
        

        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    try await writeTournamentTeams(tournament, serie: serie)
                }
            }
        }
        

    }

    func writeTournamentTeams(_ tournament: Tournament, serie: Serie) async throws {
        let docRef = db.collection("ChampionShips")
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            if let teams = tournament.teams {
                for team in teams {
                    groupTask.addTask {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .collection("Teams")
                            .document("\(team.id)")
                            .setData(from: team.self)
                        
                    }
                }
            }
        }
    }
    
    func writeSeriesTournaments(_ series: [Serie]) async throws {
        
            await withThrowingTaskGroup(of: Void.self) { groupTask in
                for serie in series {
                    groupTask.addTask {
                        try await writeSerie(serie)
                    }
                }
            }
            print("successfuly loaded serie's tournaments")
    }
    
    func wtireSerieTournaments(_ serie: Serie) async throws {
        
        let docRef = db.collection("ChampionShips")
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .setData(from: tournament.tournament.self)
                }
            }
        }
    }
    
    func writeSerie(_ serie: Serie) async throws {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            try docRef.document("\(serie.serie.id)").setData(from: serie.serie.self)
            print("successfuly loaded data")
        } catch {
            print("Firestore error - ",error)
            throw RequestError.failedWriteData
        }
    }
    
    func writeData(championShip: ChampionShip) async throws {
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for serie in championShip.series {
                groupTask.addTask {
                    try await writeSerie(serie)
                    try await wtireSerieTournaments(serie)
                    try await writeTournamentsTeams(serie: serie)
                    try await writeTournamentsMatches(serie: serie)
                    try await writeTournamentsBrackets(serie: serie)
                    try await writeTournamentsStandings(serie: serie)
                }
            }
        }
    }
    
    
    //MARK: - fetch data from fireStore if dont need to make request to Pandascore
    
    func getSeries() async throws -> [PandascoreSerie] {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            
            var series: [PandascoreSerie] = []
            
            let documents = try await docRef.getDocuments()
            
            for document in documents.documents {
                try series.append(document.data(as: PandascoreSerie.self))
            }
            
            return series
            
        } catch {
            throw RequestError.fetchingFailed
        }
    }
    
    func getSerieTournaments(_ serie: PandascoreSerie) async throws -> [PandascoreTournament] {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            
            var tournaments: [PandascoreTournament] = []
            
            let documents = try await docRef.document("\(serie.id)").collection("Tournaments").getDocuments()
            
            for document in documents.documents {
                
                try tournaments.append(document.data(as: PandascoreTournament.self))
                
            }
            
            return tournaments
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentTeams(_ tournament: PandascoreTournament, serie: PandascoreSerie) async throws -> Tournament {
        
        let docRef = db.collection("ChampionShips")
        var teams: [PandascoreTeam] = []
        
        do {
            let documents = try? await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.id)")
                .collection("Teams")
                .getDocuments()
            
            if let documents = documents {
                
                
                
                for document in documents.documents {
                    
                    try teams.append(document.data(as: PandascoreTeam.self))
                }
                
                let tournament = Tournament(tournament: tournament, teams: teams)
                return tournament
                
            } else {
                
                return Tournament(tournament: tournament)
                
            }
        } catch {
            
            print(error)
            throw RequestError.fetchingFailed
        }
        
    }
    
    
    func getTournamentsTeams(_ pandaTournaments: [PandascoreTournament], serie: PandascoreSerie) async throws -> [Tournament] {
        
        var tournaments: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in pandaTournaments {
                    taskGroup.addTask {
                        try await getTournamentTeams(tournament, serie: serie)
                    }
                }
                
                for try await result in taskGroup {
                    tournaments.append(result)
                }
            }
//            print(tournaments)
            return tournaments
            
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentMatches(_ tournament: Tournament, serie: PandascoreSerie) async throws -> Tournament {
        
        let docRef = db.collection("ChampionShips")
        var tournament = tournament
        var matches: [PandascoreMatch] = []
        
        do {
            let documents = try? await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.tournament.id)")
                .collection("Matches")
                .getDocuments()
            
            if let documents = documents {
                for document in documents.documents {
                    try matches.append(document.data(as: PandascoreMatch.self))
                }
                tournament.matches = matches
                return tournament
            } else {
                return tournament
            }
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentsMatches(_ tournaments: [Tournament], serie: PandascoreSerie) async throws -> [Tournament] {
        
        var newTournaments: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        try await getTournamentMatches(tournament, serie: serie)
                        
                    }
                }
                
                for try await result in taskGroup {
                    newTournaments.append(result)
                }
            }
            return tournaments
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    
    func getTournamentStandings(_ tournament: Tournament, serie: PandascoreSerie) async throws -> Tournament {
        
        let docRef = db.collection("ChampionShips")
        var tournament = tournament
        var matches: [PandascoreStandings] = []
        
        
        do {
            let documents = try? await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.tournament.id)")
                .collection("Standings")
                .getDocuments()
            
            if let documents = documents {
                for document in documents.documents {
                    try matches.append(document.data(as: PandascoreStandings.self))
                }
                tournament.standings = matches
                return tournament
            } else {
                return tournament
            }
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentsStandings(_ tournaments: [Tournament], serie: PandascoreSerie) async throws -> [Tournament] {
        
        var newTournaments: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        try await getTournamentStandings(tournament, serie: serie)
                    }
                }
                
                for try await result in taskGroup {
                    newTournaments.append(result)
                }
            }
            print(tournaments)
            return tournaments
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentBrackets(_ tournament: Tournament, serie: PandascoreSerie) async throws -> Tournament {
        
        let docRef = db.collection("ChampionShips")
        var tournament = tournament
        var matches: [PandascoreBrackets] = []
        
        
        do {
            let documents = try? await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.tournament.id)")
                .collection("Brackets")
                .getDocuments()
            
            if let documents = documents {
                for document in documents.documents {
                    try matches.append(document.data(as: PandascoreBrackets.self))
                }
                tournament.brackets = matches
                return tournament
            } else {
                return tournament
            }
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getTournamentsBrackets(_ tournaments: [Tournament], serie: PandascoreSerie ) async throws -> [Tournament] {
        
        var newTournaments: [Tournament] = []
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        try await getTournamentBrackets(tournament, serie: serie)
                    }
                }
                
                for try await result in taskGroup {
                    newTournaments.append(result)
                }
            }
            return tournaments
        } catch {
            print(error)
            throw RequestError.fetchingFailed
        }
    }
    
    func getData() async throws -> ChampionShip {
        
        
        var championShip = ChampionShip(series: [])
        let pandascoreSeries = try await getSeries()
        
        try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
            for serie in pandascoreSeries {
                taskGroup.addTask {
                    let tournaments = try await getSerieTournaments(serie)
                    let tournamentsWithTeams = try await getTournamentsTeams(tournaments, serie: serie)
                    let tournamentsWithMatches = try await getTournamentsMatches(tournamentsWithTeams, serie: serie)
                    let tournamentsWithBrackets = try await getTournamentsBrackets(tournamentsWithMatches, serie: serie)
                    let tournamentsWithStandings = try await getTournamentsStandings(tournamentsWithBrackets, serie: serie)
                    
//                    let tournamentsWithStandings = try await getTournamentsStandings(tournamentsWithMatches, serie: serie)
                    
                    return Serie(serie: serie, tournaments: tournamentsWithStandings)
                }
            }
            
            for try await result in taskGroup {
                championShip.series.append(result)
            }
        }
        
        return championShip
    }
    

    
    
//    func getData() async throws -> [PandascoreSerie] {
//        
//        do {
//            var championShips = ChampionShip(series: [])
//            let series = try await getSeries()
//            
//            
//            try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
//                for serie in series {
//                    let tournaments = try await getSerieTournaments(serie)
//                    let tournamentsWithTeams = try await getTournamentsTeams(_tournaments: <#T##[Tournament]#>, serie: <#T##Serie#>)
//                }
//            }
//            
////            let docRef = db.collection("ChampionShips")
////            
////            do {
////                
////                var series: [PandascoreSerie] = []
////                
////                let documents = try await docRef.getDocuments()
////                
////                for document in documents.documents {
////                    
////                    try series.append(document.data(as: PandascoreSerie.self))
////                    
////                }
////                
////                return series
////                
////            } catch {
////                print("Firestore get data error - ",error)
////                return []
////            }
//        } catch {
//            print(error)
//            throw RequestError.fetchingFailed
//        }
//        return []
//    }
}

