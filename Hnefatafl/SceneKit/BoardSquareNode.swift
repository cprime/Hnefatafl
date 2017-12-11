//
//  BoardSquareNode.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/3/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import SpriteKit

class BoardSquareNode: SKShapeNode {
    let boardSquareType: BoardSquareType
    let decorationNode: SKSpriteNode?
    
    var boardSelectionType: BoardSelectionType? {
        didSet {
            updateColors()
        }
    }
    
    var cellSize: CGFloat {
        didSet {
            updateFrames()
        }
    }
    
    init(cellSize: CGFloat, boardSquareType: BoardSquareType) {
        self.cellSize = cellSize
        self.boardSquareType = boardSquareType
        
        switch boardSquareType {
        case .kingEscape:
            decorationNode = SKSpriteNode(imageNamed: "005-viking-ship")
        case .kingStart:
            decorationNode = SKSpriteNode(imageNamed: "003-house")
        default:
            decorationNode = nil
        }
        
        super.init()
        
        if let decorationNode = decorationNode {
            decorationNode.alpha = 0.33
            addChild(decorationNode)
        }
        updateColors()
        updateFrames()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateColors() {
        var fillColor = UIColor.white
        if let boardSelectionType = boardSelectionType {
            switch boardSelectionType {
            case .selected:
                fillColor = .red
            case .possibleTarget:
                fillColor = .blue
            case .selectedTarget:
                fillColor = .green
            }
        } else {
            switch boardSquareType {
            case .kingEscape, .kingStart:
                fillColor = UIColor(white: 0.8, alpha: 1.0)
            case .open:
                fillColor = .white
            }
        }
        self.fillColor = fillColor
        self.strokeColor = .black
    }
    
    func updateFrames() {
        let path = UIBezierPath(rect: CGRect(
            x: 0,
            y: 0,
            width: cellSize,
            height: cellSize
        ))
        self.path = path.cgPath
        
        if let decorationNode = decorationNode {
            decorationNode.position = CGPoint(x: cellSize * 0.5, y: cellSize * 0.5)
            decorationNode.size = CGSize(width: cellSize, height: cellSize)
        }
    }
}
