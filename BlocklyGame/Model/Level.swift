//
//  Level.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import SpriteKit

public class Level {
    var done: Bool
    var hint: String
    var toolbox: String
    var customScene: String?
    var envyronmentSetup: (SKScene) -> Void
    var endTester: (SKScene) -> Bool
    
    init(done: Bool = false, hint: String = "", toolbox: String = "toolbox.xml", customScene: String? = nil, envyronmentSetup: @escaping (SKScene) -> Void, endTester: @escaping (SKScene) -> Bool) {
        self.done = done
        self.hint = hint
        self.toolbox = toolbox
        self.customScene = customScene
        self.envyronmentSetup = envyronmentSetup
        self.endTester = endTester
    }
}
