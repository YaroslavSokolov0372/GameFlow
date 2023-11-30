//
//  webScrapingManager.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 15/11/2023.
//

import Foundation
import SwiftSoup

enum WebScrapingError: Error {
    case parsingError
//    case didntFindTournament
    case invalidURL
}

class LiqupediaWebScraper {
    
    private let base = "https://liquipedia.net"
    
    private func parseHTMLFrom(_ customUrl: String?) async throws -> Document {
        
        guard let url = URL(string: customUrl == nil ? "https://liquipedia.net/dota2/Portal:Tournaments" : customUrl!) else {
            throw WebScrapingError.invalidURL
        }
        
        let urlData = try Data(contentsOf: url)
        let htmlString = String(data: urlData, encoding: .ascii)
        
        let document: Document = try SwiftSoup.parse(htmlString!)

        return document
        
    }
    
    private func getTierLinks() async throws -> [String : String] {
        
        var links = [String: String]()
        
        let document = try await parseHTMLFrom(nil)
        
        let navBarLinks = try document.getElementsByClass("nav nav-tabs navigation-not-searchable tabs tabs10").select("a")
        
        try await withThrowingTaskGroup(of: [String]?.self) { taskGroup in
            for navLink in navBarLinks {
                taskGroup.addTask {
                    
                    if try navLink.text().contains("Tier") || navLink.text().contains("Qualifiers") {
                        return try [navLink.text(), try navLink.attr("href")]
                    } else {
                        return nil
                    }
                }
            }
            
            for try await result in taskGroup {
                if result != nil {
                    links[result![0]] = result![1]
                }
            }
        }
        
        print(links)
        return links
    }
    
    private func hasAdditionalTabs(_ link: String) async throws -> Bool {
        
        let document = try await parseHTMLFrom("\(base)\(link)")
        
        let tabs = try document.getElementsByClass("tabs-static")
        
        if tabs.count > 1 {
            return true
        } else {
            return false
        }
    }
    
    private func getAdditionalLinks(link: String) async throws -> [String] {
        
        var stringLinks: [String] = []
        
        let document = try await parseHTMLFrom("\(base)\(link)")

        let navTab = try document.getElementsByClass("tabs-static")
        
        for tab in navTab[1...] {
            
            let htmlLinks = try tab.select("a")
            
            
            for link in htmlLinks[1...] {
                
                stringLinks.append(try link.attr("href"))
            }
            print("additional links - ", stringLinks)
        }
        
        print("string links -", stringLinks)
        return stringLinks
    }
    
    private func getPrizepool(from liqTourn: Element) async throws -> String {
                                                                  
        let liquiTournPrizepool = try liqTourn.getElementsByClass("gridCell EventDetails Prize Header").text()
        
        return liquiTournPrizepool
           
    }
    
    private func getTier(from liqTourn: Element) async throws -> String {
        
        let tournamentTier = try liqTourn.getElementsByClass("gridCell Tier Header").text()
        
        return tournamentTier
    }
    
    private func getTeamPlayers(teamInfoElement: Element) async throws -> [LiquipediaSerie.LiquipediaPlayer] {
        
        var teamPlayers: [LiquipediaSerie.LiquipediaPlayer] = []
        
        let teamPartisipants = try teamInfoElement.getElementsByClass("wikitable wikitable-bordered list").filter({ try $0.attr("data-toggle-area-content") == "1" })

        if let filteredPartisipantes = teamPartisipants.first {
            try await withThrowingTaskGroup(of: LiquipediaSerie.LiquipediaPlayer.self) { taskGroup in
                for player in try filteredPartisipantes.select("tr").prefix(5) {
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
        } else {
            throw WebScrapingError.parsingError
        }
        return teamPlayers
    }
    
     private func getTeams(from liqTourn: Element) async throws -> [LiquipediaSerie.LiquipediaTeam] {
        
        var liquipediaTeams: [LiquipediaSerie.LiquipediaTeam] = []
        
        let tournamentHeader = try liqTourn.getElementsByClass("gridCell Tournament Header")
        
        try tournamentHeader.select("span").remove()
        
        let tournamentLink = try tournamentHeader.select("a")
        
        let tournDetailLink = try await parseHTMLFrom("\(base)\(try tournamentLink.attr("href"))")
        
        
        
        
//        let teamsInfo = try tournDetailLink.getElementsByClass("template-box")
        let teamsInfo = try tournDetailLink.getElementsByClass("teamcard toggle-area toggle-area-1")
        
        
        try await withThrowingTaskGroup(of: LiquipediaSerie.LiquipediaTeam.self) { taskGroup in
            for teamInfo in teamsInfo {
                
                taskGroup.addTask {
                    
                    let teamLogo = try teamInfo.getElementsByClass("wikitable wikitable-bordered logo").select("img").attr("src")
                    
                    let teamName = try teamInfo.select("center").text()
                    
                    let players = try await self.getTeamPlayers(teamInfoElement: teamInfo)
                    
                    return LiquipediaSerie.LiquipediaTeam(imageURL: teamLogo, name: teamName, players: players)
                }
            }
            
            for try await result in taskGroup {
                liquipediaTeams.append(result)
            }
        }
        
        return liquipediaTeams
    }
    
    private func getPagesTournaments(links: [String]) async throws -> [LiquipediaSerie] {
        
        var series: [LiquipediaSerie] = []
        
        try await withThrowingTaskGroup(of: [LiquipediaSerie].self) { taskGroup in
            
            for link in links {
                
                taskGroup.addTask {
                    return try await self.getPageTournaments(link: link)
                    
                }
            }
            
            for try await result in taskGroup {
                series.append(contentsOf: result)
            }
        }
        
        return series
    }
    
    func getPageTournaments(link: String) async throws -> [LiquipediaSerie] {
        
        var liquiSeries: [LiquipediaSerie] = []
        
        let document = try await parseHTMLFrom("\(base)\(link)")
        
        let liquiTourns = try document.getElementsByClass("gridRow")
        
        do {
            try await withThrowingTaskGroup(of: LiquipediaSerie.self) { taskGroup in
                for tourn in liquiTourns {
                    taskGroup.addTask {
                        
                        let liquiTournName = try tourn.getElementsByClass("gridCell Tournament Header").text()
                        
                        let prizepool = try await self.getPrizepool(
                            from: tourn)
                        
                        let tier = try await self.getTier(
                            from: tourn)
                        
                        let teams = try await self.getTeams(from: tourn)
                        
                        return LiquipediaSerie(name: liquiTournName, prizepool: prizepool, teams: teams, tier: tier)
                        //                    detectedTour = try getTeams(from: liquiTourn, for: detectedTour)
                        
                    }
                }
                
                for try await result in taskGroup {
                    liquiSeries.append(result)
                }
            }
        } catch {
            throw WebScrapingError.parsingError
        }
        
        return liquiSeries
    }
    
    // Rewrite
    func getAllTournaments() async throws {
        
        let links = try await getTierLinks()
        
        do {
            try await withThrowingTaskGroup(of: [LiquipediaSerie].self) { taskGroup in
                
                for link in links {
                    
                    taskGroup.addTask {
                        
                        
                        if try await self.hasAdditionalTabs(link.value) {
                            // firstly have to parse current link and after others
                            let additionalLinks = try await self.getAdditionalLinks(link: link.value)
                            
                            let currentPageSeires = try await self.getPageTournaments(link: link.value)
                            
                            let tournFromAdditional = try await self.getPagesTournaments(links: additionalLinks)
                            
                            var allSeriesFromTier = currentPageSeires
                            allSeriesFromTier.append(contentsOf: tournFromAdditional)
                            print("All tournaments from \(link.key) - ", allSeriesFromTier.count)
                            return allSeriesFromTier
                            
                        } else {
                            //Just patse current link
                            
                            let currentPageSeries = try await self.getPageTournaments(link: link.value)
                            print("All tournaments from \(link.key) - ", currentPageSeries.count)
                            return currentPageSeries
                        }
                    }
                }
                for try await _ in taskGroup {
                    
                }
            }
            
        } catch {
            throw WebScrapingError.parsingError
        }
    }
}

