//
//  BoardPosition.swift
//  Hnefatafl
//
//  Created by Colden Prime on 1/2/16.
//  Copyright © 2016 Colden Prime. All rights reserved.
//

import Foundation

struct BoardPosition: Equatable, Codable {
    let column: Int
    let row: Int
    
    func move(column: Int, row: Int) -> BoardPosition {
        return BoardPosition(column: self.column + column, row: self.row + row)
    }
}

func ==(lhs: BoardPosition, rhs: BoardPosition) -> Bool {
    return lhs.column == rhs.column && lhs.row == rhs.row
}
