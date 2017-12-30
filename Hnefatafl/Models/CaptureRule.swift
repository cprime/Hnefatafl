//
//  CaptureRule.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/29/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import Foundation

struct CaptureEffect {
    let capturedPieces: [CaptureEvent]
    let victor: BoardPieceSide?
    
    static var empty: CaptureEffect {
        return CaptureEffect(capturedPieces: [], victor: nil)
    }
    
    var isEmpty: Bool {
        return capturedPieces.isEmpty && victor == nil
    }
}

func +(lhs: CaptureEffect, rhs: CaptureEffect) -> CaptureEffect {
    return CaptureEffect(capturedPieces: lhs.capturedPieces + rhs.capturedPieces, victor: lhs.victor ?? rhs.victor)
}

protocol CaptureRule {
    func evaluate(on board: Board, from: BoardPosition, to: BoardPosition) -> CaptureEffect
}

struct SoldierPinCaptureRule: CaptureRule {
    func evaluate(on board: Board, from fromPosition: BoardPosition, to toPosition: BoardPosition) -> CaptureEffect {
        var captureEffect = CaptureEffect.empty
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .up)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .down)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .right)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .left)
        return captureEffect
    }
    
    private func checkMovement(on board: Board, toPosition: BoardPosition, direction: BoardDirection) -> CaptureEffect {
        let pinnedPosition = toPosition.move(in: direction)
        guard let movingPiece = board.piece(at: toPosition),
            let pinnedPiece = board.piece(at: pinnedPosition),
            movingPiece.side != pinnedPiece.side,
            pinnedPiece.type == .soldier else {
                return CaptureEffect.empty
        }
        
        var captureEvent: CaptureEvent?
        if let otherSideSquare = board.square(at: toPosition.move(in: direction, distance: 2)) {
            if let otherPiece = otherSideSquare.piece, otherPiece.side != pinnedPiece.side {
                if let removedPiece = try? board.removePiece(at: pinnedPosition) {
                    captureEvent = CaptureEvent(position: pinnedPosition, piece: removedPiece)
                }
            } else if otherSideSquare.type == .kingEscape || otherSideSquare.type == .kingStart {
                if let removedPiece = try? board.removePiece(at: pinnedPosition) {
                    captureEvent = CaptureEvent(position: pinnedPosition, piece: removedPiece)
                }
            }
        }
        return CaptureEffect(capturedPieces: [captureEvent].flatMap({ $0 }), victor: nil)
    }
}

struct KingPinCaputureRuleL: CaptureRule {
    func evaluate(on board: Board, from fromPosition: BoardPosition, to toPosition: BoardPosition) -> CaptureEffect {
        var captureEffect = CaptureEffect.empty
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .up)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .down)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .right)
        captureEffect = captureEffect + checkMovement(on: board, toPosition: toPosition, direction: .left)
        return captureEffect
    }
    
    private func checkMovement(on board: Board, toPosition: BoardPosition, direction: BoardDirection) -> CaptureEffect {
        let pinnedPosition = toPosition.move(in: direction)
        guard
            let movingPiece = board.piece(at: toPosition),
            let pinnedPiece = board.piece(at: pinnedPosition),
            movingPiece.side != pinnedPiece.side,
            pinnedPiece.type == .king,
            let upSide = board.piece(at: pinnedPosition.move(in: .up))?.side,
            upSide != pinnedPiece.side,
            let downSide = board.piece(at: pinnedPosition.move(in: .down))?.side,
            downSide != pinnedPiece.side,
            let leftSide = board.piece(at: pinnedPosition.move(in: .left))?.side,
            leftSide != pinnedPiece.side,
            let rightSide = board.piece(at: pinnedPosition.move(in: .right))?.side,
            rightSide != pinnedPiece.side else {
                return CaptureEffect.empty
        }
        return CaptureEffect(capturedPieces: [], victor: .attacker)
    }
}
