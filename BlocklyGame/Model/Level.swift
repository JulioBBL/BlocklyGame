//
//  Level.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation

public class Level {
    var imageName: String
    var title: String
    var description: String
    var hints: [String]
    var difficulty: ToolboxType
    var steps: Int //number of smaller goals for the use to achieve
    var progress: Int //number of steps that the user has already cleared
    
    init(imageName: String = "", title: String = "Title", description: String = "description", hints: [String] = [], difficulty: ToolboxType = .extreme, steps: Int = 1, progress: Int = 0) {
        self.imageName = imageName
        self.title = title
        self.description = description
        self.hints = hints
        self.difficulty = difficulty
        self.steps = steps
        self.progress = progress
    }
}
