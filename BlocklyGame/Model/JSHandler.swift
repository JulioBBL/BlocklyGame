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
    static func say(_ text: String)
    static func changeBackgroundColor(_ color: String)
}

class JSHandler: NSObject, JSHandlerJSExport {
    var viewController: UIViewController
    var outputScene: SKScene
    
    init(view: UIViewController, scene: SKScene) {
        self.viewController = view
        self.outputScene = scene
        
        super.init()
    }
    
    //MARK: Static
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
    
    //MARK: Dynamic
    func doSay(_ text: String) {
        let alert = UIAlertController(title: "Code has said:", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.viewController.present(alert, animated: true, completion: nil)
        
        print("CODE HAS SAID: \(text)")
    }
    
    func doChangeBackgroundColor(_ color: String) {
        print(color)
        self.outputScene.backgroundColor = UIColor(hexString: color)
    }
}
