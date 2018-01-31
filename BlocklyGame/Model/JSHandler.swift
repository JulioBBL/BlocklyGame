//
//  OutputHandler.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 10/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import JavaScriptCore
import Blockly

@objc protocol JSHandlerJSExport: JSExport {
    var context: JSContext? { get set }
    
    static func highlightBlock(_ uuid: String)
    static func setTimeout()
    static func say(_ text: String)
    
    static func changeBackgroundColor(_ color: String)
    static func changeSquareColor(_ color: String)
    
    static func moveForward()
    static func rotate(_ direction: String)
    static func canGo(_ direction: String) -> JSValue
    static func hasFinished() -> JSValue
}

class JSHandler: NSObject, JSHandlerJSExport {
    static let shared = JSHandler()
    var speed: Speed = .🐢
    var context: JSContext?
    var viewController: UIViewController?
    var outputScene: SKScene?
    var currentWorkBench: WorkbenchViewController?
    
    //MARK: Static
    class func highlightBlock(_ uuid: String) {
        DispatchQueue.main.async {
            if let a = self.shared.currentWorkBench {
                a.unhighlightAllBlocks()
                a.highlightBlock(blockUUID: uuid)
            }
        }
    }
    
    class func setTimeout() {
        var ms: Int
        
        switch self.shared.speed {
        case .🐢:
            ms = 50
        default:
            ms = 10
        }
        
        usleep(useconds_t(ms * 1000))
    }
    
    class func say(_ text: String) {
        self.shared.doSay(text)
    }
    
    class func changeBackgroundColor(_ color: String) {
        self.shared.doChangeBackgroundColor(color)
    }
    
    class func changeSquareColor(_ color: String) {
        self.shared.doChangeSquareColor(color)
    }
    
    class func moveForward() {
        self.shared.doMoveForward()
    }
    
    class func rotate(_ direction: String) {
        self.shared.doRotate(direction)
    }
    
    class func canGo(_ direction: String) -> JSValue {
        return self.shared.doCanGo(direction)
    }
    
    class func hasFinished() -> JSValue {
        return self.shared.doHasFinished()
    }
    
    //MARK: Dynamic
    func displayAlert(withTitle title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action()
        }))
        if let a = self.viewController {
            a.present(alert, animated: true, completion: nil)
        }
    }
    
    func doSay(_ text: String) {
        self.displayAlert(withTitle: "Code has said:", message: text, action: {})
        
        print("CODE HAS SAID: \(text)")
    }
    
    func doChangeBackgroundColor(_ color: String) {
        if let a = self.outputScene {
            a.backgroundColor = UIColor(hexString: color)
        }
    }
    
    func doChangeSquareColor(_ color: String) {
        print(color)
        if let a = (self.outputScene?.childNode(withName: "Square") as? SKShapeNode) {
            a.fillColor = UIColor(hexString: color)
        }
    }
    
    func doMoveForward() {
        if let labirinth = self.outputScene as? LabirinthScene {
            labirinth.moveForward()
        }
    }
    
    func doRotate(_ direction: String) {
        if let labirinth = self.outputScene as? LabirinthScene {
            labirinth.rotate(direction: direction)
        }
    }
    
    func doCanGo(_ direction: String) -> JSValue {
        if let labirinth = self.outputScene as? LabirinthScene {
            return JSValue(bool: labirinth.canGo(to: direction), in: self.context)
        }
        return JSValue(bool: false, in: self.context)
    }
    
    func doHasFinished() -> JSValue {
        if let labirinth = self.outputScene as? LabirinthScene {
            return JSValue(bool: labirinth.hasFinished, in: self.context)
        }
        return JSValue(bool: false, in: self.context)
    }
}

enum Speed: Int {
    case 🐢 = 0
    case 🐇 = 1
}
