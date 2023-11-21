//
//  Network.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 19/11/2023.
//

import Foundation
import Network

class NetworkMonitor: ObservableObject {
    
    private let netoworkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
    
    init() {
        netoworkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            Task {
                await MainActor.run {
                    self.objectWillChange.send()
                }
            }
        }
    }
}
