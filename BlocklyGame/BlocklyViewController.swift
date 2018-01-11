//
//  BlocklyViewController.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 30/12/17.
//  Copyright © 2017 Julio Brazil. All rights reserved.
//

import UIKit
import SpriteKit
import Blockly

class BlocklyViewController: UIViewController {
    @IBOutlet weak var WorkbenchView: UIView!
    @IBOutlet weak var StuffView: SKView!
    
    var currentWorkbench: WorkbenchViewController?
    var codeGeneratorService: CodeGeneratorService = {
        let codeGeneratorService = CodeGeneratorService(
            jsCoreDependencies: [
                // The JS file containing the Blockly engine
                "blockly_compressed.js",
                // The JS file containing a list of internationalized messages
                "en.js"
            ])
        
        // Create builder for creating code generator service requests
        let requestBuilder = CodeGeneratorServiceRequestBuilder(
            // The name of the object containing all of the JavaScript generators
            jsGeneratorObject: "Blockly.JavaScript"
        )
        requestBuilder.addJSBlockGeneratorFiles([
            // File with JavaScript generators for all the default blocks in Blockly
            "javascript_compressed.js",
            // File with JavaScript generators for the blocks defined in `customDefinitions.json`
            "customCodeGeneratos.js"
            ])
        // Definitions for all default blocks in Blockly
        requestBuilder.addJSONBlockDefinitionFiles(fromDefaultFiles: .allDefault)
        // Definitions for custom blocks that are being used inside the workspace
        requestBuilder.addJSONBlockDefinitionFiles(["customDefinitions.json"])
        
        // Set the request builder for the CodeGeneratorService.
        codeGeneratorService.setRequestBuilder(requestBuilder, shouldCache: true)
        
        return codeGeneratorService
    }()
    
    // Store a list of all CodeRunner instances currently running JS code.
    private var codeRunners = [CodeRunner]()
    var _currentRequestUUID: String = ""

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    deinit {
        codeGeneratorService.cancelAllRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (UIApplication.shared.delegate as! AppDelegate).stuffDoer = JSHandler(view: self)
        
        // Create a workbench
        let workbenchViewController = WorkbenchViewController(style: .defaultStyle)
//        workbenchViewController.engine.config.setColor(UIColor(rgb: 0x000000, a: CGFloat(0.5)), for: DefaultLayoutConfig.BlockStrokeDefaultColor)
        self.currentWorkbench = workbenchViewController
        
        
        // Load its block factory with default blocks
        let blockFactory = workbenchViewController.blockFactory
        do {
            try blockFactory.load(fromJSONPaths: ["customDefinitions.json"])
        } catch let error {
            print("Error loading custom definitions into block factory: \(error)")
            return
        }

        blockFactory.load(fromDefaultFiles: .allDefault)
        
        // Load the toolbox into the workbench
        do {
            if let toolboxFile = Bundle.main.path(forResource: "toolbox.xml", ofType: nil) {
                // Load the XML from `toolbox.xml`
                let toolboxXML = try String(contentsOfFile: toolboxFile, encoding: String.Encoding.utf8)
                
                // Create a toolbox from the XML, using the blockFactory to create blocks declared in the XML
                let toolbox = try Toolbox.makeToolbox(xmlString: toolboxXML, factory: blockFactory)
                
                // Load the toolbox into the workbench
                try workbenchViewController.loadToolbox(toolbox)
            } else {
                print("Could not load 'toolbox.xml'")
            }

        } catch let error {
            print("Error loading toolbox into workbench: \(error)")
            return
        }
        
        // Add editor to this view controller
        addChildViewController(workbenchViewController)
        self.WorkbenchView.addSubview(workbenchViewController.view)
        workbenchViewController.view.frame = self.WorkbenchView.bounds
        workbenchViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        workbenchViewController.didMove(toParentViewController: self)
    }
    
    @IBAction func didPressPlayButton(_ sender: UIButton) {
        self.StuffView.backgroundColor = UIColor.random()
        print("Play button was pressed")
        if let currentWorkbench = self.currentWorkbench {
            self.generateJavaScriptCode(forWorkbench: currentWorkbench) { error, code in
                if error == nil {
                    if let code = code, code != "" {
                        // Create and store a new CodeRunner, so it doesn't go out of memory.
                        let codeRunner = CodeRunner()
                        self.codeRunners.append(codeRunner)
                        
                        // Run the JS code, and remove the CodeRunner when finished.
                        codeRunner.runJavascriptCode(code, completion: {
                            self.codeRunners = self.codeRunners.filter { $0 !== codeRunner }
                        })
                    } else {
                        print("No code was provided")
                    }
                }
            }
        } else {
            print("could not locate current workbech")
        }
    }
    
    func generateJavaScriptCode(forWorkbench workbench: WorkbenchViewController, completion: @escaping (Error?, String?) -> Void) {
        guard let workspace = workbench.workspace else {
            print("Workbench does not contain a workspace.")
            return
        }
        
        do {
            _currentRequestUUID = try codeGeneratorService.generateCode(
                forWorkspace: workspace,
                onCompletion: { requestUUID, code in
                    print("JavaScript code generation was successful:\n\(code)")
                    completion(nil, code)
            },
                onError: { requestUUID, error in
                    print("JavaScript code generation failed:\n\(error)")
                    completion(CodeGenerationError.generationFailed(error), nil)
            })
        } catch let error {
            print("Could not create code request:\n\(error)")
            completion(error, nil)
        }
    }
    
//    func saveBlocks() {
//        // Save the workspace to disk
//        if let workspace = self.currentWorkbench?.workspace {
//            do {
//                let xml = try workspace.toXML()
//                FileHelper.saveContents(xml, to: "workspace.xml")
//            } catch let error {
//                print("Couldn't save workspace to disk: \(error)")
//            }
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

enum CodeGenerationError: Error {
    case generationFailed(String)
}
