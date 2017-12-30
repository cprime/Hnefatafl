//
//  BoardPosition.swift
//  Hnefatafl
//
//  Created by Colden Prime on 1/2/16.
//  Copyright © 2016 Colden Prime. All rights reserved.
//

import Foundation

enum BoardDirection {
    case up
    case down
    case left
    case right
}

struct BoardPosition: Equatable, Codable {
    let column: Int
    let row: Int
    
    func move(in direction: BoardDirection, distance: Int = 1) -> BoardPosition {
        switch direction {
        case .up:
            return BoardPosition(column: self.column, row: self.row + distance)
        case .down:
            return BoardPosition(column: self.column, row: self.row - distance)
        case .right:
            return BoardPosition(column: self.column + distance, row: self.row)
        case .left:
            return BoardPosition(column: self.column - distance, row: self.row)
        }
    }
    
    static func direction(from: BoardPosition, to: BoardPosition) -> BoardDirection {
        guard from != to else {
            fatalError()
        }
        if from.column == to.column {
            if from.row < to.row {
                return .up
            } else {
                return .down
            }
        } else {
            if from.column < to.column {
                return .right
            } else {
                return .left
            }
        }
    }
}

func ==(lhs: BoardPosition, rhs: BoardPosition) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
