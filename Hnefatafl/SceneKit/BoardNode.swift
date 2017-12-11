//
//  BoardNode.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/3/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import SpriteKit

protocol BoardNodeDelegate: class {
    func boardNode(_ boardNode: BoardNode, didTapBoardSquareAt position: BoardPosition)
}

class BoardNode: SKNode {
    struct AnimationDuration {
        static let move: TimeInterval = 0.25
        static let fade: TimeInterval = 0.25
    }
    
    struct Layer {
        static let tile: CGFloat = 0
        static let piece: CGFloat = 1
    }
    
    var cellSize: CGFloat = 50 {
        didSet {
            updateNodePositions()
        }
    }
    
    let board: Board
    var squareNodes = [[BoardSquareNode]]()
    var pieceNodes = [[BoardPieceNode?]]()
    weak var delegate: BoardNodeDelegate?
    
    init(board: Board) {
        self.board = board
        super.init()
        self.isUserInteractionEnabled = true
        
        for i in 0..<board.columns {
            var columnOfSquares = [BoardSquareNode]()
            var columnOfPieces = [BoardPieceNode?]()
            for j in 0..<board.rows {
                if let square = board.square(at: BoardPosition(column: i, row: j)) {
                    let squareNode = BoardSquareNode(cellSize: cellSize, boardSquareType: square.type)
                    squareNode.position = CGPoint(x: CGFloat(i) * cellSize, y: CGFloat(j) * cellSize)
                    squareNode.zPosition = Layer.tile
                    columnOfSquares.append(squareNode)
                    addChild(squareNode)
                    
                    if let piece = square.piece {
                        let pieceNode = BoardPieceNode(cellSize: cellSize, boardPiece: piece)
                        pieceNode.position = squareNode.position
                        pieceNode.zPosition = Layer.piece
                        columnOfPieces.append(pieceNode)
                        addChild(pieceNode)
                    } else {
                        columnOfPieces.append(nil)
                    }
                }
            }
            squareNodes.append(columnOfSquares)
            pieceNodes.append(columnOfPieces)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateNodePositions() {
        for i in 0..<board.columns {
            for j in 0..<board.rows {
                let squareNode = squareNodes[i][j]
                squareNode.cellSize = cellSize
                squareNode.position = CGPoint(x: CGFloat(i) * cellSize, y: CGFloat(j) * cellSize)
                
                if let pieceNode = pieceNodes[i][j] {
                    pieceNode.cellSize = squareNode.cellSize
                    pieceNode.position = squareNode.position
                }
            }
        }
    }
    
    func update(boardSelection: BoardSelection, turn: Turn?) {
        for (x, column) in boardSelection.spaces.enumerated() {
            for (y, type) in column.enumerated() {
                let squareNode = squareNodes[x][y]
                squareNode.boardSelectionType = type
            }
        }
        if let turn = turn, let pieceNode = pieceNodes[turn.from.column][turn.from.row] {
            pieceNodes[turn.to.column][turn.to.row] = pieceNode
            
            let to = CGPoint(x: CGFloat(turn.to.column) * cellSize, y: CGFloat(turn.to.row) * cellSize)
            let moveAction = SKAction.move(to: to, duration: AnimationDuration.move)
            pieceNode.run(moveAction, completion: {
                for (position, _) in turn.capturedPieces {
                    if let caputuredPieceNode = self.pieceNodes[position.column][position.row] {
                        self.pieceNodes[position.column][position.row] = nil
                        
                        let fadeAction = SKAction.fadeOut(withDuration: AnimationDuration.fade)
                        caputuredPieceNode.run(fadeAction, completion: {
                            caputuredPieceNode.removeFromParent()
                        })
                    }
                }
            })
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.phase == .ended else {
            return
        }
        let tapPosition = touch.location(in: self)
        let row = Int(floor(tapPosition.y / cellSize))
        let column = Int(floor(tapPosition.x / cellSize))
        delegate?.boardNode(self, didTapBoardSquareAt: BoardPosition(column: column, row: row))
    }
}
