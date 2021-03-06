//
//  BoardSquare.swift
//  Hnefatafl
//
//  Created by Prime, Colden on 11/26/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum BoardSquareType: Int, Codable {
    case kingStart
    case open
    case kingEscape
}

struct BoardSquare: Codable {
    let type: BoardSquareType
    var piece: BoardPiece?

    init(type: BoardSquareType) {
        self.type = type
    }
}
