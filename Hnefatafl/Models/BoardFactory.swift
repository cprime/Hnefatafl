//
//  BoardFactory.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/29/15.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

class BoardFactory {
    func createBoard() -> Board {
        var spaces = [[BoardSquare]]()
        for _ in 0..<11 {
            var row = [BoardSquare]()
            for _ in 0..<11 {
                row.append(BoardSquare(type: .open))
            }
            spaces.append(row)
        }

        spaces[0][0] = BoardSquare(type: .kingEscape)
        spaces[10][0] = BoardSquare(type: .kingEscape)
        spaces[0][10] = BoardSquare(type: .kingEscape)
        spaces[10][10] = BoardSquare(type: .kingEscape)

        spaces[5][5] = BoardSquare(type: .kingStart)

        //Defenders
        spaces[5][5].piece = BoardPiece(side: .defender, type: .king)

        spaces[4][4].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[4][5].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[4][6].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[5][4].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[5][6].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[6][4].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[6][5].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[6][6].piece = BoardPiece(side: .defender, type: .soldier)

        spaces[5][3].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[5][7].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[3][5].piece = BoardPiece(side: .defender, type: .soldier)
        spaces[7][5].piece = BoardPiece(side: .defender, type: .soldier)

        //Attackers
        spaces[0][3].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[0][4].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[0][5].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[0][6].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[0][7].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[1][5].piece = BoardPiece(side: .attacker, type: .soldier)

        spaces[10][3].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[10][4].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[10][5].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[10][6].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[10][7].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[9][5].piece = BoardPiece(side: .attacker, type: .soldier)

        spaces[3][0].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[4][0].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[5][0].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[6][0].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[7][0].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[5][1].piece = BoardPiece(side: .attacker, type: .soldier)

        spaces[3][10].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[4][10].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[5][10].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[6][10].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[7][10].piece = BoardPiece(side: .attacker, type: .soldier)
        spaces[5][9].piece = BoardPiece(side: .attacker, type: .soldier)

        return Board(spaces: spaces)
    }
    
}
