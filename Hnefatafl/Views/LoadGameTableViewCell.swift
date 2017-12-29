//
//  LoadGameTableViewCell.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/22/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import UIKit

class LoadGameTableViewCell: UITableViewCell {
    static let reuseIdentifier = "LoadGameTableViewCell"
    
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var lastMoveLabel: UILabel!
    
    func configure(with viewModel: LoadGameViewModel) {
        playerLabel.text = viewModel.player
        turnLabel.text = viewModel.turn
        lastMoveLabel.text = viewModel.lastMove
    }
    
}
