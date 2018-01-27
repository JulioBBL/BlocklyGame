//
//  Challenge.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 22/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation

protocol Challenge {
    var imageName: String { get set }
    var title: String { get set }
    var description: String { get set }
    var difficulty: Difficulty { get set }
    var levels: [Level] { get set }
    var steps: Int { get }
    var progress: Int { get }
}
