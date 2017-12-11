//
//  GameScene.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/5/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation
import SpriteKit

class GameScene: SKScene {
    let game: Game
    let boardNode: BoardNode
    let statusNode: SKLabelNode
    let boardSelection: BoardSelection
    
    init(size: CGSize, game: Game) {
        self.game = game
        self.boardNode = BoardNode(board: game.board)
        self.statusNode = SKLabelNode(text: "12345")
        self.boardSelection = BoardSelection(game: game)
        
        super.init(size: size)
        
        boardNode.delegate = self
        addChild(boardNode)
        
        statusNode.horizontalAlignmentMode = .left
        addChild(statusNode)
        
        updateState()
        updateFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateFrames()
    }
    
    fileprivate func updateState(with turn: Turn? = nil) {
        boardNode.update(boardSelection: boardSelection, turn: turn)
        
        switch boardSelection.state {
        case .idle:
            if (game.isComplete) {
                statusNode.text = game.victor == .defender ? "Saxons Wins!" : "Vikings Wins!"
            } else {
                statusNode.text = game.activeSide == .defender ? "Saxons' Turn" : "Vikings' Turn"
            }
        case .pieceSelected(_):
            statusNode.text = "Select Target Location"
        case .targetSelected(_):
            statusNode.text = "Confirm Selection"
        }
    }
    
    private func updateFrames() {
        boardNode.cellSize = size.width / CGFloat(game.board.columns)
        statusNode.position = CGPoint(x: 0, y: boardNode.cellSize * CGFloat(game.board.columns) + 5)
    }
}

extension GameScene: BoardNodeDelegate {
    func boardNode(_ boardNode: BoardNode, didTapBoardSquareAt position: BoardPosition) {
        print(#function, position)
        guard let square = game.board.square(at: position) else {
            return
        }
        var turn: Turn?
        switch boardSelection.state {
        case .idle:
            if let piece = square.piece {
                if game.activeSide == piece.side {
                    boardSelection.setPieceSelected(selected: position)
                }
            }
            break
        case let .pieceSelected(selected, _):
            if position == selected {
                boardSelection.setIdle()
            } else {
                if game.canMove(from: selected, to: position) {
                    boardSelection.setTargetSelected(selected: selected, target: position)
                }
            }
            break
        case let .targetSelected(selected, target, _):
            if position == selected {
                boardSelection.setIdle()
            } else if position == target {
                turn = game.move(from: selected, to: target)
                boardSelection.setIdle()
            } else {
                boardSelection.setIdle()
            }
            break
        }
        updateState(with: turn)
    }
}

