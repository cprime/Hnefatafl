//
//  BoardPieceNode.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/5/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import SpriteKit

class BoardPieceNode: SKNode {
    let boardPiece: BoardPiece
    let spriteNote: SKSpriteNode
    
    var cellSize: CGFloat {
        didSet {
            updateFrames()
        }
    }
    
    init(cellSize: CGFloat, boardPiece: BoardPiece) {
        self.boardPiece = boardPiece
        self.cellSize = cellSize
        switch boardPiece.type {
        case .king:
            spriteNote = SKSpriteNode(imageNamed: "004-viking")
        case .soldier:
            switch boardPiece.side {
            case .defender:
                spriteNote = SKSpriteNode(imageNamed: "006-shield")
            case .attacker:
                spriteNote = SKSpriteNode(imageNamed: "007-skull")
            }
        }
        
        super.init()
        
        addChild(spriteNote)
        updateFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateFrames() {
        let spriteScaler: CGFloat
        switch boardPiece.type {
        case .king:
            spriteScaler = 0.95
        default:
            spriteScaler = 0.65
        }
        
        spriteNote.position = CGPoint(x: cellSize * 0.5, y: cellSize * 0.5)
        spriteNote.size = CGSize(width: cellSize * spriteScaler, height: cellSize * spriteScaler)
    }
}
