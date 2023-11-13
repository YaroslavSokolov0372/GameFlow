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
    
    //MARK: - rewrite data to fireStore in case shouldPandascoreReq()
    
    
    

    
    func writeTournamentsStandings(serie: Serie) async throws {
        let docRef = db.collection("ChampionShips")

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
            
            if let standings = tournament.standings {
                for standing in standings {
                    groupTask.addTask {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .collection("Standings")
                            .document("\(standing.team)")
                            .setData(from: standing.self)
                        
                    }
                }
            }
        }
    }
    
    func writeTournamentsBrackets(serie: Serie) async throws {
        
        let docRef = db.collection("ChampionShips")

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
                            .collection("Teams")
                            .document("\(bracket.id)")
                            .setData(from: bracket.self)
                        
                    }
                }
            }
        }
    }
    
    func writeTournamentsMatches(serie: Serie) async throws {
        
        let docRef = db.collection("ChampionShips")

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
        
        let docRef = db.collection("ChampionShips")

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
        
        let docRef = db.collection("ChampionShips")
        
//        do {
            await withThrowingTaskGroup(of: Void.self) { groupTask in
                for serie in series {
                    groupTask.addTask {
                        try await writeSerie(serie)
                    }
                }
            }
            print("successfuly loaded serie's tournaments")
            
//        } catch {
//            print(error)
//        }
    }
    
    func wtireSerieTournaments(_ serie: Serie) async throws {
        let docRef = db.collection("ChampionShips")
        
        await withThrowingTaskGroup(of: Void.self) { groupTask in
            for tournament in serie.tournaments {
                groupTask.addTask {
//                    do {
                        try docRef
                            .document("\(serie.serie.id)")
                            .collection("Tournaments")
                            .document("\(tournament.tournament.id)")
                            .setData(from: tournament.tournament.self)
//                    } catch {
//                        print("Failed to write tournament to firestore")
//                        throw RequestError.failedWriteData
//                    }
                    
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
    
    
    
    func writeData(championShip: ChampionShip) async -> () {
        
        for serie in championShip.series {
            
        }
    }
    
    
    
    //MARK: - fetch data from fireStore if dont need to make request to Pandascore
    
    func getTournamentsStandings() async throws -> [PandascoreMatch] {
        return []
    }
    
    func getTournamentsBrackets() async throws -> [PandascoreMatch] {
        return []
    }
    
    func getTournamentsTeam() async throws -> [PandascoreTeam] {
        return []
    }
    
    func getSeriesTournaments() async throws -> [PandascoreTournament] {
        return []
    }
    
    func getSeries() async throws -> [PandascoreSerie] {
        return []
    }
 
    func getData() async throws -> [PandascoreSerie] {
        
        let docRef = db.collection("ChampionShips")
        
        do {
            
            var series: [PandascoreSerie] = []
            
            let documents = try await docRef.getDocuments()
            
            for document in documents.documents {
                
                try series.append(document.data(as: PandascoreSerie.self))
                
            }
            
            return series
            
        } catch {
            print("Firestore get data error - ",error)
            return []
        }
    }
}

