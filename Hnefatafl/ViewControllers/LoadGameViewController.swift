//
//  LoadGameViewController.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/15/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import UIKit

class LoadGameViewController: UITableViewController {
    var gameRecords = [LoadGameViewModel]()
    var gameToPush: Game?
    
    func reloadData() {
        gameRecords = GameStore.shared.savedGames().map(LoadGameViewModel.init)
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LoadGameTableViewCell.reuseIdentifier, for: indexPath) as! LoadGameTableViewCell
        let gameRecord = gameRecords[indexPath.row]
        cell.configure(with: gameRecord)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let gameRecord = gameRecords[indexPath.row]
        GameStore.shared.delete(gameRecord.gameRecord)
        gameRecords.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        gameToPush = gameRecords[indexPath.row].gameRecord.game
        performSegue(withIdentifier: "newGameSegue", sender: self)
    }

    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue", let gameController = segue.destination as? GameViewController, let game = gameToPush {
            gameController.game = game
        }
        
        gameToPush = nil
    }
}
