//
//  UIColor+Random.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 02/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    public static func random() -> UIColor {
        let r = Int(arc4random_uniform(UInt32(256)))
        let b = Int(arc4random_uniform(UInt32(256)))
        let g = Int(arc4random_uniform(UInt32(256)))
        
        return UIColor(red: r, green: g, blue: b)
    }
}
