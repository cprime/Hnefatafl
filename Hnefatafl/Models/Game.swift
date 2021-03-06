//
//  Game.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/30/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum GameError: Error {
    case unknown
}

class Game: Codable {
    let identifier: String
    var board: Board
    var turns = [Turn]()
    var undoneTurns = [Turn]()
    var activeSide: BoardPieceSide = .defender

    var victor: BoardPieceSide?

    var isComplete: Bool {
        return victor != nil
    }

    init(board: Board) {
        self.identifier = UUID().uuidString
        self.board = board
    }

    func canMove(from: BoardPosition, to: BoardPosition) -> Bool {
        guard !isComplete,
            ((from.row != to.row && from.column == to.column) || (from.row == to.row && from.column != to.column)),
            let fromSquare = board.square(at: BoardPosition(column: from.column, row: from.row)),
            let fromPiece = fromSquare.piece,
            let toSquare = board.square(at: BoardPosition(column: to.column, row: to.row)),
            toSquare.piece == nil else {
            return false
        }

        if toSquare.type == .kingStart {
            return false
        }
        if toSquare.type == .kingEscape && fromPiece.type != .king {
            return false
        }
        if from.row == to.row && abs(from.column - to.column) > 0 {
            // Horizontal
            for column in min(from.column, to.column)+1..<max(from.column, to.column) {
                if board.piece(at: BoardPosition(column: column, row: from.row)) != nil {
                    return false
                }
            }
        } else if from.column == to.column && abs(from.row - to.row) > 0 {
            // Vertical
            for row in min(from.row, to.row)+1..<max(from.row, to.row) {
                if board.piece(at: BoardPosition(column: from.column, row: row)) != nil {
                    return false
                }
            }
        } else {
            return false
        }

        return true
    }

    func move(from: BoardPosition, to: BoardPosition) -> Turn {
        let fromPosition = BoardPosition(column: from.column, row: from.row)
        let toPosition = BoardPosition(column: to.column, row: to.row)
        guard let piece = board.piece(at: fromPosition),
            let _ = try? board.movePiece(from: fromPosition, to: toPosition) else {
            fatalError("Illegal Move")
        }

        // Check for Capture
        var capturedPieces = [CaptureEvent?]()
        capturedPieces += [checkMovement(toPosition: toPosition, direction: .up)]
        capturedPieces += [checkMovement(toPosition: toPosition, direction: .down)]
        capturedPieces += [checkMovement(toPosition: toPosition, direction: .left)]
        capturedPieces += [checkMovement(toPosition: toPosition, direction: .right)]

        // Check for King Escape
        for column in 0..<board.columns {
            for row in 0..<board.columns {
                if let square = board.square(at: BoardPosition(column: column, row: row)),
                    let piece = square.piece,
                    square.type == .kingEscape,
                    piece.type == .king {
                    victor = .defender
                }
            }
        }

        let turn = Turn(piece: piece,
                        from: fromPosition,
                        to: toPosition,
                        capturedPieces: capturedPieces.flatMap({ $0 }),
                        completesGame: isComplete)
        turns.append(turn)
        undoneTurns.removeAll()
        activeSide = (activeSide == .attacker ? .defender : .attacker)
        
        return turn
    }

    private func checkMovement(toPosition: BoardPosition, direction: BoardDirection) -> CaptureEvent? {
        let pinnedPosition = toPosition.move(in: direction)
        
        guard let movingPiece = board.piece(at: toPosition),
            let pinnedPiece = board.piece(at: pinnedPosition),
            movingPiece.side != pinnedPiece.side else {
                return nil
        }
        
        if pinnedPiece.type == .soldier {
            if let otherSideSquare = board.square(at: toPosition.move(in: direction, distance: 2)) {
                if let otherPiece = otherSideSquare.piece, otherPiece.side != pinnedPiece.side {
                    if let removedPiece = try? board.removePiece(at: pinnedPosition) {
                        return CaptureEvent(position: pinnedPosition, piece: removedPiece)
                    } else {
                        return nil
                    }
                } else if otherSideSquare.type == .kingEscape || otherSideSquare.type == .kingStart {
                    if let removedPiece = try? board.removePiece(at: pinnedPosition) {
                        return CaptureEvent(position: pinnedPosition, piece: removedPiece)
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } else if pinnedPiece.type == .king {
            if let upSide = board.piece(at: pinnedPosition.move(in: .up))?.side,
                upSide != pinnedPiece.side,
                let downSide = board.piece(at: pinnedPosition.move(in: .down))?.side,
                downSide != pinnedPiece.side,
                let leftSide = board.piece(at: pinnedPosition.move(in: .left))?.side,
                leftSide != pinnedPiece.side,
                let rightSide = board.piece(at: pinnedPosition.move(in: .right))?.side,
                rightSide != pinnedPiece.side {
                victor = .attacker
                return nil
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func canRedoTurn() -> Bool {
        return undoneTurns.count > 0
    }
    
    func redoTurn() throws -> Turn {
        guard let nextMove = undoneTurns.last else {
            throw GameError.unknown
        }
        undoneTurns.removeLast()
        turns.append(nextMove)
        
        try board.movePiece(from: nextMove.from, to: nextMove.to)
        try nextMove.capturedPieces.forEach { event in
            _ = try board.removePiece(at: event.position)
        }
        if nextMove.completesGame {
            victor = nextMove.piece.side
        }
        activeSide = (activeSide == .attacker ? .defender : .attacker)
        
        return nextMove
    }
    
    func canUndoTurn() -> Bool {
        return turns.count > 0
    }
    
    func undoTurn() throws -> Turn {
        guard let lastMove = turns.last else {
            throw GameError.unknown
        }
        turns.removeLast()
        undoneTurns.append(lastMove)
        
        try board.movePiece(from: lastMove.to, to: lastMove.from)
        try lastMove.capturedPieces.forEach { event in
            try board.add(event.piece, at: event.position)
        }
        if lastMove.completesGame {
            victor = nil
        }
        activeSide = (activeSide == .attacker ? .defender : .attacker)
        
        return lastMove
    }
}
