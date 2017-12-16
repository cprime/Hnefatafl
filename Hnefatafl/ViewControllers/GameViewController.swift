//
//  GameViewController.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/3/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    @IBOutlet weak var skView: SKView!
    
    var game: Game!
    var scene: GameScene!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if game == nil {
            let boardFactory = BoardFactory()
            let board = boardFactory.createBoard()
            game = Game(board: board)
        }
        scene = GameScene(size:view.bounds.size, game: game)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        skView.presentScene(scene)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene.size = view.bounds.size
    }
}
