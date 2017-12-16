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
    
    let backButtonNode: SimpleButtonNode = {
        return SimpleButtonNode(initialCellSize: 50, pathFactory: { (cellSize) -> CGPath in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: cellSize, y: 0))
            path.addLine(to: CGPoint(x: 0, y: cellSize * 0.5))
            path.addLine(to: CGPoint(x: cellSize, y: cellSize))
            return path.cgPath
        })
    }()
    
    let forwardButtonNode: SimpleButtonNode = {
        return SimpleButtonNode(initialCellSize: 50, pathFactory: { (cellSize) -> CGPath in
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: cellSize, y: cellSize * 0.5))
            path.addLine(to: CGPoint(x: 0, y: cellSize))
            return path.cgPath
        })
    }()
    
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
        
        backButtonNode.action = {
            self.undoTurn()
        }
        addChild(backButtonNode)
        
        forwardButtonNode.action = {
            self.redoTurn()
        }
        addChild(forwardButtonNode)
        
        updateFrames()
        updateStatusLabel()
        updateButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didChangeSize(_ oldSize: CGSize) {
        super.didChangeSize(oldSize)
        updateFrames()
    }

    
    private func updateButtons() {
        backButtonNode.isEnabled = game.canUndoTurn()
        forwardButtonNode.isEnabled = game.canRedoTurn()
    }
    
    private func updateStatusLabel() {
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
        boardNode.position = CGPoint(x: 0, y: size.height - size.width)
        
        statusNode.position = CGPoint(x: 8, y: boardNode.position.y - statusNode.frame.size.height - 8)
        
        forwardButtonNode.cellSize = statusNode.frame.size.height
        forwardButtonNode.position = CGPoint(x: size.width - forwardButtonNode.cellSize - 8, y: statusNode.position.y)
        
        backButtonNode.cellSize = forwardButtonNode.cellSize
        backButtonNode.position = CGPoint(x: forwardButtonNode.position.x - backButtonNode.cellSize - 8, y: statusNode.position.y)
    }
    
    fileprivate func undoTurn() {
        guard case .idle = boardSelection.state, game.canUndoTurn(), let turn = (try? game.undoTurn()) else {
            return
        }
        boardSelection.setIdle()
        boardNode.applyBackwards(turn)
        updateStatusLabel()
        updateButtons()
    }
    
    fileprivate func redoTurn() {
        guard case .idle = boardSelection.state, game.canRedoTurn(), let turn = (try? game.redoTurn()) else {
            return
        }
        boardSelection.setIdle()
        boardNode.applyForward(turn)
        updateStatusLabel()
        updateButtons()
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
                } else {
                    boardSelection.setIdle()
                }
            }
            break
        case let .targetSelected(selected, target, _):
            if position == selected {
                boardSelection.setIdle()
            } else if position == target {
                if game.canMove(from: selected, to: position) {
                    turn = game.move(from: selected, to: target)
                }
                boardSelection.setIdle()
            } else {
                boardSelection.setIdle()
            }
            break
        }
        
        boardNode.apply(boardSelection)
        if let turn = turn {
            let data = try! JSONEncoder().encode(game)
            print(String(data: data, encoding: String.Encoding.utf8)!)
            boardNode.applyForward(turn)
        }
        updateStatusLabel()
        updateButtons()
    }
}

