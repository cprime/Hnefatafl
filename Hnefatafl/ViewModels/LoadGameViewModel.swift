//
//  LoadGameViewModel.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/22/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import Foundation

struct LoadGameViewModel {
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    let gameRecord: GameRecord
    
    var player: String {
        let turnModifier = gameRecord.game.isComplete ? "Victor" : "Active Player"
        let player: String
        if let victor = gameRecord.game.victor {
            switch victor {
            case .attacker:
                player = "Viking"
            case .defender:
                player = "Saxon"
            }
        } else {
            switch gameRecord.game.activeSide {
            case .attacker:
                player = "Viking"
            case .defender:
                player = "Saxon"
            }
        }
        return "\(turnModifier): \(player)"
    }
    
    var turn: String {
        return "\(gameRecord.game.turns.count) turns"
    }
    
    var lastMove: String {
        return "Last Move: \(LoadGameViewModel.dateFormatter.string(from: gameRecord.updated))"
    }
}
