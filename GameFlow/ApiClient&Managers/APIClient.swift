//
//  SearchQueryClient.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI
import ComposableArchitecture
import Alamofire


//MARK: - Basic fetch for pandascore
/// fetch upcomingSeries
/// fetch runningSeries
/// fetch pastSeries
/// fetch tournaments for each Series
/// fetch roasters(or teams) for a tournaments
/// fetch brackets if exist, if don't, then standings
/// fetch matches for tournaments

//So, firstly I make request to firebase to check last dateStamp to know when last time was fetching pandascor
// if last time was more than 1 hour, then go fetch daata from pandascore and rewrite to firebase, if less, then fetch from firebase

class ApiClient {
    
    private let firestoreManager = FirestoreManager()
    private let pandascoreManager = PandascoreManager()
    private let webScrapingManager = LiqupediaWebScraper()
    
    
    func getFirestoreSeries() async throws -> [Serie] {
        return try await self.firestoreManager.getSeries()
    }
    
    func writeDataToFirestore(_ series: [Serie]) async throws {
        try await self.firestoreManager.writeData(series: series)
    }
    
    func getRelevantLiquiSeries() async throws -> [LiquipediaSerie] {
        
        return try await self.webScrapingManager.getPageTournaments(link: "/dota2/Portal:Tournaments")
        
    }
    
    func fetchRelevantPandaSeries() async throws -> [Serie] {
        
        var series: [Serie] = []
        let ongoingSeries = try await self.pandascoreManager.getPandaSeries(fetchType: .ongoing)
        let upcomingSeries = try await self.pandascoreManager.getPandaSeries(fetchType: .upciming)
        let pastSeries = try await self.pandascoreManager.getPandaSeries(fetchType: .past)
        //        let liquiSeries = try await self.webScrapingManager.
        
        var allRelevant = ongoingSeries
        allRelevant.append(contentsOf: upcomingSeries)
        allRelevant.append(contentsOf: pastSeries)
        
        
        try await withThrowingTaskGroup(of: Serie.self) { taskGroup in
            for pandaSerie in allRelevant {
                taskGroup.addTask {
                    
                    let tournaments = try await self.pandascoreManager.setupTournamentsFrom(pandaSerie)
                    
                    return Serie(serie: pandaSerie, tournaments: tournaments, liquipeadiaSerie: nil)
                }
                
            }
            
            
            for try await result in taskGroup {
                series.append(result)
            }
            
        }
        print(series.count)
        return series
    }
    
    func filteredSeries(liquiSeries: [LiquipediaSerie], pandaSeries: [Serie]) async throws -> [Serie] {
        
        var filteredTournaments: [Serie] = []
        
        for var serie in pandaSeries {
            for liquiSerie in liquiSeries {
                
                var liquiTournName = liquiSerie.name
                liquiTournName = liquiTournName.replacingOccurrences(of: "#", with: "")
                liquiTournName = liquiTournName.replacingOccurrences(of: ":", with: "")
                liquiTournName = liquiTournName.replacingOccurrences(of: " ", with: "")
                liquiTournName = liquiTournName.replacingOccurrences(of: "-", with: "")
                liquiTournName = liquiTournName.uppercased()
                liquiTournName = String(liquiTournName.sorted())
                
                
                var pandaSerie = serie.fullName
                pandaSerie = pandaSerie.replacingOccurrences(of: " ", with: "")
                pandaSerie = pandaSerie.uppercased()
                pandaSerie = String(pandaSerie.sorted())
                
                let difference = zip(liquiTournName, pandaSerie).filter{$0 != $1}
                
                if difference.count == 0 {
                    print("match")
                    print(serie.serie.id)
                    serie.liquipediaSerie = liquiSerie
                    filteredTournaments.append(serie)
                } else {
                    
                    pandaSerie = serie.fullName
                    pandaSerie = pandaSerie.replacingOccurrences(of: "2023", with: "")
                    pandaSerie = pandaSerie.replacingOccurrences(of: "Cup", with: "")
                    pandaSerie = pandaSerie.replacingOccurrences(of: " ", with: "")
                    pandaSerie = pandaSerie.uppercased()
                    pandaSerie = String(pandaSerie.sorted())
                    
                    let difference = zip(liquiTournName, pandaSerie).filter{$0 != $1}
                    
                    if difference.count <= 2 {
                        print("New match")
                        print(serie.serie.id)
                        serie.liquipediaSerie = liquiSerie
                        filteredTournaments.append(serie)
                    }
                }
            }
        }
        return filteredTournaments
    }
    
}
