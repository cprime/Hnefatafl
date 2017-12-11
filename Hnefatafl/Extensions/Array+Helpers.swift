//
//  Array+Helpers.swift
//  Hnefatafl
//
//  Created by Colden Prime on 12/1/17.
//  Copyright © 2017 Colden Prime. All rights reserved.
//

import Foundation

extension Array {
    subscript(safely index: Int) -> Element? {
        get {
            guard index >= 0 && index < count else { return nil }
            return self[index]
        }
    }
}
