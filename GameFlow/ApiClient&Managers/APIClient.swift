//
//  SearchQueryClient.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 09/10/2023.
//

import SwiftUI

class ApiClient {
    
    private let firestoreManager = FirestoreManager()
    private let pandascoreManager = PandascoreManager()
    private let webScrapingManager = LiqupediaWebScraper()
    
    
//    func getFirestoreSeries() async throws -> [Serie] {
//        return try await self.firestoreManager.getSeries()
//    }
    
//    func writeDataToFirestore(_ series: [Serie]) async throws {
//        try await self.firestoreManager.writeData(series: series)
//    }
    
//    func getRelevantLiquiSeries() async throws -> [LiquipediaSerie] {
//        
//        return try await self.webScrapingManager.getPageTournaments(link: "/dota2/Portal:Tournaments")
//        
//    }
    
    
    
    func getData() async throws -> [Serie] {
        
        var serie: [Serie]?
        
        if try await self.firestoreManager.shouldPandaFetch() {
            try await self.firestoreManager.prepareForFetch {
                try await self.firestoreManager.writeDateStamp()
                
                let liquiSerie = try await self.webScrapingManager.getPageTournaments(link: "/dota2/Portal:Tournaments")
                let pandaSerie = try await self.pandascoreManager.fetchRelevantPandaSeries()
                try await self.firestoreManager.writeData(series: try await self.filteredSeries(liquiSeries: liquiSerie, pandaSeries: pandaSerie))
                
                serie = try await self.firestoreManager.getSeries()
            }
        } else {
            return try await self.firestoreManager.getSeries()
        }
            
        guard let serie = serie else {
            throw PandascoreError.pandaFetchingFailed
        }
        
        return serie
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
