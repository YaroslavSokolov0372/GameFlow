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


enum RequestError: Error {
case invalidURL
case fetchingFailed
case failedWriteData
case parsigError
case didntFindTournament
}




enum FirestoreError: Error {
    case failedWriteData
    case failedFetchingData
    case didntFindData
}

class FirestoreManager {
    
    private let db = Firestore.firestore()
    
    func delete() async throws {
        
    }
    
    //MARK: - Function to know whether I need to make Pandascore request or not
    
     func getLastDateStamp() async throws -> String {
        
        let docRef = db.collection("DateStamps").document("LastFetch")
        
        do {
            let document = try await docRef.getDocument()
            
            if let data = document.data() {
                return data["DateStamp"] as! String
            } else {
                throw FirestoreError.didntFindData
            }
        } catch {
            throw FirestoreError.failedFetchingData
        }
    }
    
    func prepareForFetch(closure: @escaping () async throws -> ()) async throws {
        
        let docRef = db.collection("DateStamps").document("WhoWillFetch")
        
        let uuid = UUID()
        
        
        do {
            try await docRef.setData(["uuid" : uuid.description])
        } catch {
            throw FirestoreError.failedWriteData
        }
        
        try await Task.sleep(for: .seconds(2))
        
        let lastUUID = try await docRef.getDocument().data()
        
        if lastUUID!["uuid"] as! String == uuid.description {
            try await closure()
        }
    }
    
     func writeDateStamp() async throws {
        
        let docRef = db.collection("DateStamps").document("LastFetch")
        
        let currentTime = Date().iso8601
        
        do {
            try await docRef.setData(["DateStamp" : currentTime])
        } catch {
            throw FirestoreError.failedWriteData
        }
    }
    
    func shouldPandaFetch() async throws  -> Bool {
        
        
        let lastFetch = try await getLastDateStamp()
        
        let lastStamp = lastFetch.ISOfotmattedString()
        let currentTime = Date().iso8601.ISOfotmattedString()
        
        let calendar = Calendar(identifier: .iso8601)
        
        let difference = calendar.dateComponents([.month, .day, .hour, .minute], from:  lastStamp, to: currentTime )
        
        
        if let hours = difference.hour {
            if hours > 1 {
                return true
            } else {
                if let minutes = difference.minute {
                    print(minutes)
                    if minutes > 30 {
                        return true
                    } else {
                        return false
                    }
                } else {
                    return false
                }
            }
        } else {
            return false
        }
    }
    
    
    //MARK: - rewrite data to fireStore have to make request to Pandascore
    
    func writeTournamentsStandings(serie: Serie) async throws {

        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
                    try await self.writeTournamentStandings(tournament, serie: serie)
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
                    try await self.writeTournamentBrackets(tournament, serie: serie)
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
                    try await self.writeTournamentMatches(tournament, serie: serie)
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
                    try await self.writeTournamentTeams(tournament, serie: serie)
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
                        try await self.writeSerie(serie)
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
    
    func writeLiquiSerie(_ serie: Serie) async throws {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            try docRef
                .document("\(serie.serie.id)")
                .collection("LiquiSerie")
                .document("\(serie.serie.id)")
                .setData(from: serie.liquipediaSerie.self)
        } catch {
            
            throw FirestoreError.failedWriteData
        }
        
    }
    
    func writeData(series: [Serie]) async throws {
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for serie in series {
                groupTask.addTask {
                    try await self.writeSerie(serie)
                    try await self.wtireSerieTournaments(serie)
                    try await self.writeTournamentsTeams(serie: serie)
                    try await self.writeTournamentsMatches(serie: serie)
                    try await self.writeTournamentsBrackets(serie: serie)
                    try await self.writeTournamentsStandings(serie: serie)
                    try await self.writeLiquiSerie(serie)
                }
            }
        }
    }
    
    
    //MARK: - fetch data from fireStore if dont need to make request to Pandascore
    
    func getPandaSeries() async throws -> [PandascoreSerie] {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            
            var series: [PandascoreSerie] = []
            
            let documents = try await docRef.getDocuments()
            
            for document in documents.documents {
                try series.append(document.data(as: PandascoreSerie.self))
            }
            
            return series
            
        } catch {
//            throw RequestError.fetchingFailed
            throw FirestoreError.failedFetchingData
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
//            throw RequestError.fetchingFailed
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getPandaTournamentTeams(_ tournament: PandascoreTournament, from serie: PandascoreSerie) async throws -> [PandascoreTeam] {
        
        let docRef = db.collection("ChampionShips")
        var teams: [PandascoreTeam] = []
        
        do {
            let documents = try await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.id)")
                .collection("Teams")
                .getDocuments()
                
                for document in documents.documents {
                    
                    try teams.append(document.data(as: PandascoreTeam.self))
                }
                
                return teams
                
        } catch {
            
            print(error)
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getPandaTournamentMatches(_ tournament: PandascoreTournament, from serie: PandascoreSerie) async throws -> [PandascoreMatch] {
        
        let docRef = db.collection("ChampionShips")
        var matches: [PandascoreMatch] = []
        
        do {
            let documents = try await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.id)")
                .collection("Matches")
                .getDocuments()
            
            
                for document in documents.documents {
                    try matches.append(document.data(as: PandascoreMatch.self))
                }
                return matches

        } catch {
            print(error)
            print("Match failed")
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getPandaTournamentStandings(_ tournament: PandascoreTournament, from serie: PandascoreSerie) async throws -> [PandascoreStandings] {
        
        let docRef = db.collection("ChampionShips")
        var standings: [PandascoreStandings] = []
        
        
        do {
            let documents = try await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.id)")
                .collection("Standings")
                .getDocuments()
        
                for document in documents.documents {
                    
                    try standings.append(document.data(as: PandascoreStandings.self))
                    
                }
            
                return standings
            
        } catch {
            print(error)
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getPandaTournamntBrackets(_ tournament: PandascoreTournament, from serie: PandascoreSerie) async throws -> [PandascoreBrackets] {
        
        let docRef = db.collection("ChampionShips")
        var brackets: [PandascoreBrackets] = []
        
        do {
            let documents = try await docRef
                .document("\(serie.id)")
                .collection("Tournaments")
                .document("\(tournament.id)")
                .collection("Brackets")
                .getDocuments()
            
            
                for document in documents.documents {
                    try brackets.append(document.data(as: PandascoreBrackets.self))
                }
                
                return brackets

        } catch {
            
            print(error)
            throw FirestoreError.failedFetchingData
            
        }
    }
    
    func getTournamentsData(for serie: PandascoreSerie, tournaments: [PandascoreTournament]) async throws -> [Tournament] {
        
        var newTournaments = [Tournament]()
        
        do {
            try await withThrowingTaskGroup(of: Tournament.self) { taskGroup in
                for tournament in tournaments {
                    taskGroup.addTask {
                        
                        let pandaTeams = try await self.getPandaTournamentTeams(tournament, from: serie)
                        let pandaMatches = try await self.getPandaTournamentMatches(tournament, from: serie)
                        let pandaStandings = try await self.getPandaTournamentStandings(tournament, from:serie)
                        let pandaBrackets = try await self.getPandaTournamntBrackets(tournament, from: serie)
                        return Tournament(tournament: tournament, teams: pandaTeams, matches: pandaMatches, standings: pandaStandings, brackets: pandaBrackets)
                        
                    }
                }
                
                for try await result in taskGroup {
                    newTournaments.append(result)
                }
            }
            
            return newTournaments
        } catch {
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getLiquiData(for serie: PandascoreSerie) async throws -> LiquipediaSerie {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            let document = try await docRef
                .document("\(serie.id)")
                .collection("LiquiSerie")
            //change later to search by id
                .document("\(serie.id)")
                .getDocument()
            
            let liquiInfo = try document.data(as: LiquipediaSerie.self)
            
            print(liquiInfo.name)
            return liquiInfo
        } catch {
            throw FirestoreError.failedFetchingData
        }
    }
    
    func getSeries() async throws -> [Serie] {
        
        
        var series = [Serie]()
        let pandascoreSeries = try await getPandaSeries()
        
        try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
            
            for pandaSerie in pandascoreSeries {
                taskGroup.addTask {
                    let pandaTournaments = try await self.getSerieTournaments(pandaSerie)
                    let tournaments = try await self.getTournamentsData(for: pandaSerie, tournaments: pandaTournaments)
                    let liquiInfo = try await self.getLiquiData(for: pandaSerie)
                    
                    return Serie(serie: pandaSerie, tournaments: tournaments, liquipeadiaSerie: liquiInfo, imageName: DotaImages.allCases.randomElement()!.rawValue)
                }
            }
            
            for try await result in taskGroup {
                series.append(result)
            }
        }
        
        print(series.count)
        return series
    }
}

