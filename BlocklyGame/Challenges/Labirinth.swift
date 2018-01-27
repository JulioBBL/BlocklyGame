//
//  Labirinth.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 26/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import SpriteKit

class Labirinth: Challenge {
    var imageName: String = ""
    var title: String = "Labirinth Challenge"
    var description: String = "Guide the player to the end of the labirinth"
    var difficulty: Difficulty = .intermediate
    
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
        self.levels = [Level(hint: "move forward 4 times to reach the goal (green square)",
                             toolbox: "Ch2_Lv1.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (5,4)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level1Map")
                                }
        },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
        }),
                       Level(hint: "Reach the goal (green square) but now you have to make a turn",
                             toolbox: "Ch2_Lv2.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (6,3)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level2Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       }),
                       Level(hint: "Use the repeat block so you don't have to use a lot of blocks",
                             toolbox: "Ch2_Lv3.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (4,2)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level3Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       }),
                       Level(hint: "Now you will need to use the If block to check if there is a path ahead of you",
                             toolbox: "Ch2_Lv4.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (5,2)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level4Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       }),
                       Level(hint: "You already know the basics, get to the green square",
                             toolbox: "Ch2_Lv4.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (3,6)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level5Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       }),
                       Level(hint: "You've mastered the basics by now, tme to get a little bit harder",
                             toolbox: "Ch2_Lv4.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (3,2)
                                    labirinth.initialPlayerRotation = 0
                                    labirinth.setup(mapName: "Level6Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       }),
                       Level(hint: "Time for the real test of your strength",
                             toolbox: "Ch2_Lv4.xml",
                             customScene: "LabirinthChallenge",
                             envyronmentSetup: { scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    labirinth.initialPlayerPosition = (2,1)
                                    labirinth.initialPlayerRotation = 3
                                    labirinth.setup(mapName: "Level7Map")
                                }
                       },
                             endTester: {scene in
                                if let labirinth = (scene as? LabirinthScene) {
                                    return labirinth.hasFinished
                                } else {
                                    return false
                                }
                       })]
    }
}
