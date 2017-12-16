//
//  BoardPiece.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/29/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum BoardPieceSide: Int, Codable {
    case attacker
    case defender
}

enum BoardPieceType: Int, Codable {
    case king
    case soldier
}

struct BoardPiece: Codable {
    let side: BoardPieceSide
    let type: BoardPieceType
}
