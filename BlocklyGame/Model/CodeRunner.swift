//
//  CodeRunner.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 10/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import Foundation
import JavaScriptCore

/**
 Runs JavaScript code.
 */
class CodeRunner {
    /// Use a JSContext object, which contains a JavaScript virtual machine.
    private var context: JSContext?
    
    /// Create a background thread, so the main thread isn't blocked when executing JS code.
    private let jsThread = DispatchQueue(label: "jsContext")
    
    init() {
        // Initialize the JSContext object on the background thread since that's where code execution will occur.
        jsThread.async {
            // Initialize a new context
            self.context = JSContext()
            
            // Define a handler for JavaScript exceptions
            self.context?.exceptionHandler = { context, exception in
                let error = exception?.description ?? "unknown error"
                print("JS Error: \(error)")
            }
            
            // Define the path to the JS interpreter
            guard let jsInterpreterPath = Bundle.main.path(forResource: "acorn_interpreter", ofType: "js"),
                let interpreterHandlerPath = Bundle.main.path(forResource: "interpreterHandler", ofType: "js") else {
                print("Unable to read resource files.")
                return
            }
            
            // Evaluate the JS interpreter, doing so, makes the interpreter's code available to the JS virutal machine
            do {
                let common = try String(contentsOfFile: jsInterpreterPath, encoding: String.Encoding.utf8)
                _ = self.context?.evaluateScript(common)
                
                let handler = try String(contentsOfFile: interpreterHandlerPath, encoding: String.Encoding.utf8)
                _ = self.context?.evaluateScript(handler)
            } catch (let error) {
                print("Error while processing script file: \(error)")
            }
            
            // Register custom class 'JSHandler' class with the JSContext object. This tells JSContext to route any JavaScript calls to 'JSHandler' back to iOS code.
            self.context?.setObject(JSHandler.self, forKeyedSubscript: "JSHandler" as NSString)
        }
    }
    
    /**
     Runs Javascript code on a background thread.
     
     - parameter code: The Javascript code.
     - parameter completion: Closure that is called on the main thread when the code has finished executing.
     */
    func runJavascriptCode(_ code: String, completion: @escaping () -> Void) {
        jsThread.async {
            guard let context = self.context else {
                print("JSContext not found.")
                return
            }
            // Set the playing variable to true
            self.context?.setObject(true, forKeyedSubscript: "isPlaying" as NSString)
            
            // Call the function that steps through the code
            let stepCodeFunction = context.objectForKeyedSubscript("stepInterpretedCode")
            _ = stepCodeFunction?.call(withArguments: [code])
            
            // When it finishes, call the completion closure on the main thread.
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func stopJavascriptCode() {
        self.context?.setObject(false, forKeyedSubscript: "isPlaying" as NSString)
    }
}
