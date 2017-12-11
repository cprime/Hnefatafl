//
//  BoardPiece.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/29/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum BoardPieceSide {
    case attacker
    case defender
}

enum BoardPieceType {
    case king
    case soldier
}

struct BoardPiece {
    let side: BoardPieceSide
    let type: BoardPieceType

    init(side: BoardPieceSide, type: BoardPieceType) {
        self.side = side
        self.type = type
    }
}
