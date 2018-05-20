//
//  Storage Manager.swift
//  bubbletime
//
//  Created by Jonathan Moallem on 3/5/18.
//  Copyright © 2018 Sudo-Code Software. All rights reserved.
//

import Foundation

struct StorageManager {
    
    // Fields
    let playerScoresArchive: URL
    let gameSettingsArchive: URL
    
    init() {
        // Set up the archive URLs
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        playerScoresArchive = documentsDirectory.appendingPathComponent("player_scores")
            .appendingPathExtension("json")
        gameSettingsArchive = documentsDirectory.appendingPathComponent("game_settings")
            .appendingPathExtension("json")
    }
    
    func save(scores: [PlayerScore]) throws {
        // Encode and write the data
        let data = try JSONEncoder().encode(scores)
        try write(data, to: playerScoresArchive)
    }
    
    func save(settings: GameSettings) throws {
        // Encode and write the data
        let data = try JSONEncoder().encode(settings)
        try write(data, to: gameSettingsArchive)
    }
    
    func loadScores() throws -> [PlayerScore] {
        // Read and decode the data
        let data = try read(from: playerScoresArchive)
        if let scores = try? JSONDecoder().decode([PlayerScore].self, from: data) {
            return scores
        }
        throw DataAccessError.valueNotRecognised
    }
    
    func loadSettings() throws -> GameSettings {
        // Read and decode the data
        let data = try read(from: gameSettingsArchive)
        if let settings = try? JSONDecoder().decode(GameSettings.self, from: data) {
            return settings
        }
        throw DataAccessError.valueNotRecognised
    }
    
    func read(from archive: URL) throws -> Data {
        // Attempt to read the data
        if let data = try? Data(contentsOf: archive) {
            return data
        }
        throw DataAccessError.valueNotFound
    }
    
    func write(_ data: Data, to archive: URL) throws {
        // Attempt to write the data
        do {
            try data.write(to: archive, options: .noFileProtection)
        }
        catch {
            throw DataAccessError.valueNotSaved
        }
    }
}

// An enum of storage manager errors
enum DataAccessError: Error {
    case valueNotFound
    case valueNotSaved
    case valueNotRecognised
}
