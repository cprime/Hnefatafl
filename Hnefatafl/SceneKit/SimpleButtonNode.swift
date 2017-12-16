//
//  SimpleButtonNode.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/11/17.
//  Copyright © 2017 ColdenPrime. All rights reserved.
//

import Foundation
import SpriteKit

class SimpleButtonNode: SKShapeNode {
    let pathFactory: (CGFloat) -> CGPath
    var action: (() -> Void)?
    var isEnabled: Bool = true {
        didSet {
            lineWidth = isEnabled ? 3.0 : 1.0
        }
    }
    
    var cellSize: CGFloat = 50 {
        didSet {
            self.path = pathFactory(cellSize)
        }
    }
    
    init(initialCellSize: CGFloat, pathFactory: @escaping (CGFloat) -> CGPath, action: (() -> Void)? = nil) {
        self.cellSize = initialCellSize
        self.pathFactory = pathFactory
        self.action = action
        super.init()
        self.path = pathFactory(initialCellSize)
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first,
            touch.phase == .ended,
            isEnabled else {
            return
        }
        let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        if frame.contains(touch.location(in: self)) {
            action?()
        }
    }
}
