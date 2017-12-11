//
//  Board.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/29/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum BoardError: Error {
    case unknown
}

class Board {
    // spaces[column][row] : collection of columns
    private var spaces: [[BoardSquare]]

    var rows: Int {
        return spaces.count
    }

    var columns: Int {
        return rows > 0 ? (spaces[safely: 0] ?? []).count : 0
    }

    init(spaces: [[BoardSquare]]) {
        let rowCount = spaces[safely: 0]?.count ?? 0
        guard spaces.reduce(true, { $0 && ($1.count == rowCount) }) else {
            fatalError("All columns must have the same height")
        }
        self.spaces = spaces
    }

    func square(at position: BoardPosition) -> BoardSquare? {
        return spaces[safely: position.column]?[safely: position.row]
    }

    func squareType(at position: BoardPosition) -> BoardSquareType? {
        return spaces[safely: position.column]?[safely: position.row]?.type
    }

    func piece(at position: BoardPosition) -> BoardPiece? {
        return spaces[safely: position.column]?[safely: position.row]?.piece
    }

    func add(_ piece: BoardPiece, at position: BoardPosition) throws {
        guard let square = spaces[safely: position.column]?[safely: position.row],
            square.piece == nil else {
            throw BoardError.unknown
        }
        spaces[position.column][position.row].piece = piece
    }

    func movePiece(from fromPosition: BoardPosition, to toPosition: BoardPosition) throws {
        let piece = try removePiece(at: fromPosition)
        try add(piece, at: toPosition)
    }

    func removePiece(at position: BoardPosition) throws -> BoardPiece {
        guard let square = spaces[safely: position.column]?[safely: position.row],
            let piece = square.piece else {
            throw BoardError.unknown
        }
        spaces[position.column][position.row].piece = nil
        return piece
    }
}
