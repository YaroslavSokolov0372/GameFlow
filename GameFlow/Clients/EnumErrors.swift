//
//  EnumErrors.swift
//  GameFlow
//
//  Created by Yaroslav Sokolov on 12/11/2023.
//

import Foundation


enum RequestError: Error {
    case invalidURL
    case fetchingFailed
    case failedWriteData
    
}
