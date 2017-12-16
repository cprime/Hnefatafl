//
//  Move.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/30/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

struct CaptureEvent: Codable {
    let position: BoardPosition
    let piece: BoardPiece
}

struct Turn: Codable {
    var piece: BoardPiece
    var from: BoardPosition
    var to: BoardPosition
    var capturedPieces: [CaptureEvent]
    var completesGame: Bool
}
