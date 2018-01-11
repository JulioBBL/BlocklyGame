//
//  OutputHandler.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 10/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore

@objc protocol JSHandlerJSExport: JSExport {
    static func say(_ text: String)
}

class JSHandler: NSObject, JSHandlerJSExport {
    var view: UIViewController
    
    init(view: UIViewController) {
        self.view = view
        super.init()
    }
    
    //MARK: Static
    static func say(_ text: String) {
        DispatchQueue.main.async {
            if let a = (UIApplication.shared.delegate as! AppDelegate).stuffDoer {
                a.doSay(text)
            }
        }
    }
    
    //MARK: Dynamic
    func doSay(_ text: String) {
        let alert = UIAlertController(title: "Code has said:", message: text, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.view.present(alert, animated: true, completion: nil)
        
        print("CODE HAS SAID: \(text)")
    }
}
