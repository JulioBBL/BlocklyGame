//
//  Int+toBoolean.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation

extension Int {
    func toBool() -> Bool {
        return !(self == 0)
    }
}
