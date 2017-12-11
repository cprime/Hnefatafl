//
//  BoardSelection.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/30/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

enum BoardSelectionState {
    case idle
    case pieceSelected(selected: BoardPosition, possibleTargets: [BoardPosition])
    case targetSelected(selected: BoardPosition, target: BoardPosition, travelPath: [BoardPosition])
}

enum BoardSelectionType {
    case selected
    case possibleTarget
    case selectedTarget
}

class BoardSelection {
    let game: Game
    
    var state: BoardSelectionState = .idle
    var spaces: [[BoardSelectionType?]]

    init(game: Game) {
        self.game = game
        
        spaces = [[BoardSelectionType?]]()
        for _ in 0..<game.board.columns {
            var row = [BoardSelectionType?]()
            for _ in 0..<game.board.rows {
                row.append(nil)
            }
            spaces.append(row)
        }
    }

    func setIdle() {
        state = .idle
        clearAllSelection()
    }

    func setPieceSelected(selected: BoardPosition) {
        let possibleTargets = findPossibleTargets(from: selected)
        
        state = .pieceSelected(selected: selected, possibleTargets: possibleTargets)
        clearAllSelection()

        spaces[selected.column][selected.row] = .selected
        for position in possibleTargets {
            spaces[position.column][position.row] = .possibleTarget
        }
    }

    func setTargetSelected(selected: BoardPosition, target: BoardPosition) {
        let travelPath = findTravelPath(from: selected, to: target)
        
        state = .targetSelected(selected: selected, target: target, travelPath: travelPath)
        clearAllSelection()

        spaces[selected.column][selected.row] = .selected
        for position in travelPath {
            spaces[position.column][position.row] = .possibleTarget
        }
        spaces[target.column][target.row] = .selectedTarget
    }

    fileprivate func clearAllSelection() {
        for i in 0..<spaces.count {
            for j in 0..<spaces[i].count {
                spaces[i][j] = nil
            }
        }
    }
    
    fileprivate func findPossibleTargets(from position: BoardPosition) -> [BoardPosition] {
        var possibleTargets = [BoardPosition]()
        for x in 0..<game.board.columns {
            for y in 0..<game.board.rows {
                let toPosition = BoardPosition(column: x, row: y)
                if game.canMove(from: position, to: toPosition) {
                    possibleTargets.append(toPosition)
                }
            }
        }
        return possibleTargets
    }
    
    fileprivate func findTravelPath(from fromPosition: BoardPosition, to toPosition: BoardPosition) -> [BoardPosition] {
        var travelPath = [BoardPosition]()
        if fromPosition.column != toPosition.column {
            let minColumn = min(fromPosition.column, toPosition.column)
            let maxColumn = max(fromPosition.column, toPosition.column)
            for column in minColumn+1..<maxColumn {
                travelPath.append(BoardPosition(column: column, row: toPosition.row))
            }
        } else if fromPosition.row != toPosition.row {
            let minRow = min(fromPosition.row, toPosition.row)
            let maxRow = max(fromPosition.row, toPosition.row)
            for row in minRow+1..<maxRow {
                travelPath.append(BoardPosition(column: fromPosition.column, row: row))
            }
        }
        return travelPath
    }

}
