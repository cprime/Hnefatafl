//
//  Move.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/30/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

struct Turn {
    var piece: BoardPiece
    var from: BoardPosition
    var to: BoardPosition
    var capturedPieces: [(BoardPosition, BoardPiece)]
    var completesGame: Bool
}
