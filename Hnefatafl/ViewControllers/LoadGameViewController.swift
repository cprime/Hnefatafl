//
//  LoadGameViewController.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/15/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import UIKit

class LoadGameViewController: UITableViewController {
    var gameRecords = [GameRecord]()
    var gameToPush: Game?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameRecords = GameStore.shared.savedGames()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameRecords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let gameRecord = gameRecords[indexPath.row]
        cell.textLabel?.text = "\(gameRecord.updated)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        gameToPush = gameRecords[indexPath.row].game
        performSegue(withIdentifier: "newGameSegue", sender: self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newGameSegue", let gameController = segue.destination as? GameViewController, let game = gameToPush {
            gameController.game = game
        }
        
        gameToPush = nil
    }
}
