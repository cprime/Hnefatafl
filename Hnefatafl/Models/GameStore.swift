//
//  GameStore.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/16/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import Foundation

struct GameRecord: Codable {
    static let recordPrefix = "game.saved"
    
    let game: Game
    let updated: Date
    
    fileprivate var recordKey: String {
        return "\(GameRecord.recordPrefix).\(game.identifier)"
    }
}

class GameStore {
    static let shared = GameStore()
    
    func savedGames() -> [GameRecord] {
        let defaults = UserDefaults.standard
        let decoder = JSONDecoder()
        return defaults.dictionaryRepresentation().keys
            .filter({ $0.starts(with: GameRecord.recordPrefix) })
            .flatMap({ defaults.object(forKey: $0) as? Data })
            .flatMap({ (try? decoder.decode(GameRecord.self, from: $0)) })
        
    }
    
    func save(_ game: Game) {
        let gameRecord = GameRecord(game: game, updated: Date())
        let encoder = JSONEncoder()
        if let json = try? encoder.encode(gameRecord) {
            UserDefaults.standard.set(json, forKey: gameRecord.recordKey)
        }
    }
    
    func delete(_ gameRecord: GameRecord) {
        UserDefaults.standard.removeObject(forKey: gameRecord.recordKey)
    }
}
