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

@objc protocol JSHandlerJSExport: JSExport {
    var context: JSContext { get set }
    
    static func highlightBlock(_ uuid: String)
    static func setTimeout(_ ms: Int)
    static func say(_ text: String)
    
    static func changeBackgroundColor(_ color: String)
    static func changeSquareColor(_ color: String)
    
    static func moveForward()
    static func rotate(_ direction: String)
    static func canGo(_ direction: String) -> JSValue
    static func hasFinished() -> JSValue
}

class JSHandler: NSObject, JSHandlerJSExport {
    var context: JSContext
    var viewController: UIViewController
    var outputScene: SKScene
    
    init(view: UIViewController, scene: SKScene) {
        self.viewController = view
        self.outputScene = scene
        self.context = JSContext()
        
        super.init()
    }
    
    //MARK: Static
    class func highlightBlock(_ uuid: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).currentWorkBench {
                a.unhighlightAllBlocks()
                a.highlightBlock(blockUUID: uuid)
            }
        }
    }
    
    class func setTimeout(_ ms: Int) {
        usleep(useconds_t(ms * 1000))
    }
    
    class func say(_ text: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doSay(text)
            }
        }
    }
    
    class func changeBackgroundColor(_ color: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doChangeBackgroundColor(color)
            }
        }
    }
    
    class func changeSquareColor(_ color: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doChangeSquareColor(color)
            }
        }
    }
    
    class func moveForward() {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doMoveForward()
            }
        }
    }
    
    class func rotate(_ direction: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doRotate(direction)
            }
        }
    }
    
    //DON'T LOOK AT THIS FUNCTION, YOUR EYES MAY BLEED
    class func canGo(_ direction: String) -> JSValue {
        var value = JSValue()
        if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
            value = a.doCanGo(direction)
        }
        return value
    }
    
    //DON'T LOOK AT THIS FUNCTION, YOUR EYES MAY BLEED
    class func hasFinished() -> JSValue {
        var value = JSValue()
        if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
            value = a.doHasFinished()
        }
        return value
    }
    
    //MARK: Dynamic
    func displayAlert(withTitle title: String, message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            action()
        }))
        self.viewController.present(alert, animated: true, completion: nil)
    }
    
    func doSay(_ text: String) {
        self.displayAlert(withTitle: "Code has said:", message: text, action: {})
        
        print("CODE HAS SAID: \(text)")
    }
    
    func doChangeBackgroundColor(_ color: String) {
        print(color)
        self.outputScene.backgroundColor = UIColor(hexString: color)
    }
    
    func doChangeSquareColor(_ color: String) {
        print(color)
        (self.outputScene.childNode(withName: "Square") as! SKShapeNode).fillColor = UIColor(hexString: color)
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
