//
//  MainMenuViewController.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/15/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import UIKit

class MainMenuViewController: UITableViewController {
    enum Menu: Int {
        case newGame = 0
        case loadGame = 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch Menu(rawValue: indexPath.row) {
        case .some(.newGame):
            performSegue(withIdentifier: "newGameSegue", sender: self)
        case .some(.loadGame):
            performSegue(withIdentifier: "loadGameSegue", sender: self)
        default:
            break
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue", let gameController = segue.destination as? GameViewController {
            let boardFactory = BoardFactory()
            let board = boardFactory.createBoard()
            gameController.game = Game(board: board)
        } else if segue.identifier == "loadGameSegue", let loadController = segue.destination as? LoadGameViewController {
            print(segue, loadController)
        }
    }
}
