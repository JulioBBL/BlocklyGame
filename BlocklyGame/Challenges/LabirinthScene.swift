//
//  LabirinthScene.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 26/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import SpriteKit
import GameplayKit

class LabirinthScene: SKScene {
    let tileGroups = SKTileSet(named: "Labirinth")?.tileGroups
    
    var initialPlayerPosition: (Int, Int)?
    var initialPlayerRotation: Int?
    var mapName: String?
    
    var playerPosition: (Int, Int) = (0,0)
    var playerRotation: Int = 0 {
        didSet {
            if self.playerRotation < 0 {
                self.playerRotation = 3
            } else if self.playerRotation > 3 {
                self.playerRotation = 0
            }
        }
    }
    
    var hasFinished: Bool {
        get {
            guard let map = self.map else {
                return false
            }
            
            if let def = map.tileGroup(atColumn: playerPosition.0, row: playerPosition.1) {
                return def.name == "Goal"
            } else {
                return false
            }
        }
    }
    
    var map: SKTileMapNode?
    var playerMap: SKTileMapNode?
    
    override func didMove(to view: SKView) {
        // Initialization code goes here
    }
    
    func setup(mapName: String) {
        guard let map = childNode(withName: mapName) as? SKTileMapNode, let playerMap = childNode(withName: "PlayerMap") as? SKTileMapNode else {
            fatalError("SKTileMap not found")
        }
        
        if let playerPosition = self.initialPlayerPosition, let playerRotation = self.initialPlayerRotation {
            self.plopPlayer(atColumn: playerPosition.0, row: playerPosition.1, rotation: playerRotation)
        }
        
        self.mapName = mapName
        self.map = map
        self.playerMap = playerMap
        
        let otherNodes = self.children.filter{ $0 != playerMap && $0 != map }
        for node in otherNodes {
            node.removeFromParent()
        }
    }
    
    func plopPlayer(atColumn column: Int, row: Int, rotation: Int) {
        guard let playerMap = childNode(withName: "PlayerMap") as? SKTileMapNode else {
            fatalError("SKTileMap not found")
        }
        
        //TODO clear player map
        playerMap.setTileGroup(nil, forColumn: self.playerPosition.0, row: self.playerPosition.1)

        self.playerPosition = (column, row)
        self.playerRotation = rotation
        
        playerMap.setTileGroup(self.tileGroups?.first(where: {$0.name == "Player"}), forColumn: column, row: row)
        let def = playerMap.tileDefinition(atColumn: column, row: row)!
        def.rotation = SKTileDefinitionRotation(rawValue: UInt(self.playerRotation))!
        playerMap.setTileGroup((self.tileGroups?.first(where: {$0.name == "Player"}))!, andTileDefinition: def, forColumn: column, row: row)
    }
    
    func rotate(direction: String) {
        switch direction {
        case "clockwise":
            self.playerRotation -= 1
        case "counterclockwise":
            self.playerRotation += 1
        default:
            self.playerRotation -= 1
        }
        
        self.plopPlayer(atColumn: self.playerPosition.0, row: self.playerPosition.1, rotation: self.playerRotation)
    }
    
    func canGo(to: String) -> Bool {
        guard let map = self.map else {
            fatalError("Something went wrong")
        }
        
        var direction: Int = 0 {
            didSet {
                if direction > 3 {
                    direction = 0
                } else if direction < 0 {
                    direction = 3
                }
            }
        }
        
        switch to {
        case "W": // ahead
            direction = self.playerRotation
        case "A": // left
            direction = self.playerRotation + 1
        case "D": // right
            direction = self.playerRotation - 1
        default: // backwards
            direction = self.playerRotation + 2
        }
        
        var nextPosition: (Int, Int)
        
        switch direction {
        case 0: // up
            nextPosition = (self.playerPosition.0, self.playerPosition.1 + 1)
        case 1: // left
            nextPosition = (self.playerPosition.0 - 1, self.playerPosition.1)
        case 2: // down
            nextPosition = (self.playerPosition.0, self.playerPosition.1 - 1)
        default: // right
            nextPosition = (self.playerPosition.0 + 1, self.playerPosition.1)
        }
        
        return map.tileDefinition(atColumn: nextPosition.0, row: nextPosition.1) != nil
    }
    
    func moveForward() {
        guard let map = self.map, let playerMap = self.playerMap else {
            fatalError("Something went wrong")
        }
        
        var nextPosition: (Int, Int)
        
        if let def = playerMap.tileDefinition(atColumn: playerPosition.0, row: playerPosition.1) {
            self.playerRotation = def.rotation.hashValue
            
            switch self.playerRotation {
            case 0: // up
                nextPosition = (self.playerPosition.0, self.playerPosition.1 + 1)
            case 1: // left
                nextPosition = (self.playerPosition.0 - 1, self.playerPosition.1)
            case 2: // down
                nextPosition = (self.playerPosition.0, self.playerPosition.1 - 1)
            default: // right
                nextPosition = (self.playerPosition.0 + 1, self.playerPosition.1)
            }
            
            if let _ = map.tileDefinition(atColumn: nextPosition.0, row: nextPosition.1) {
                self.plopPlayer(atColumn: nextPosition.0, row: nextPosition.1, rotation: def.rotation.hashValue)
            } else {
                //TODO say to the player that he cannot move outside of the path
                DispatchQueue.main.async {
                    if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                        a.displayAlert(withTitle: "Oops", message: "You cannot leave the path", action: {
                            self.setup(mapName: self.mapName ?? "")
                        })
                        (a.viewController as! BlocklyViewController).codeRunner.stopJavascriptCode()
                        (a.viewController as! BlocklyViewController).isPlaying = false
                    }
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
