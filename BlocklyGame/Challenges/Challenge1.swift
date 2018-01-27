//
//  Challenge1.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 22/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import SpriteKit

class Challenge1: Challenge {
    var imageName: String = ""
    var title: String = "Hello World"
    var description: String = "this is a description"
    var difficulty: Difficulty = .begginer
    
    var levels: [Level]
    var steps: Int {
        get {
            return levels.count
        }
    }
    var progress: Int {
        get {
            return levels.filter({ $0.done }).count
        }
    }
    
    init() {
        self.levels = [Level(hint: "Change the color of the square",
                             toolbox: "toolbox.xml",
                             //TODO toolbox: "Ch1_Lv1.xml",
                             envyronmentSetup: { scene in
                                let square = SKShapeNode(rect: CGRect(x: -100, y: -100, width: 200, height: 200))
                                square.name = "Square"
                                square.fillColor = UIColor.turquoise
                                square.strokeColor = UIColor.clear
                                scene.addChild(square)
                             },
                             endTester: {scene in
                                return (scene.childNode(withName: "Square") as! SKShapeNode).fillColor != UIColor.turquoise
                             }),
        
                       Level(hint: "change the collor of the square to black",
                             toolbox: "Ch1_Lv1.xml",
                             envyronmentSetup: { scene in
                                let square = SKShapeNode(rect: CGRect(x: -100, y: -100, width: 200, height: 200))
                                square.name = "Square"
                                square.fillColor = UIColor.turquoise
                                square.strokeColor = UIColor.clear
                                scene.addChild(square)
                       },
                             endTester: {scene in
                                return (scene.childNode(withName: "Square") as! SKShapeNode).fillColor == UIColor(rgb: 0x000000)
                       })]
    }
}
