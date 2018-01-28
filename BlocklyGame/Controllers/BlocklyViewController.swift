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
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var hintView: UIView!
    @IBOutlet weak var hintLabel: UILabel!
    
    var isPlaying: Bool = false {
        didSet {
            if self.isPlaying {
                self.playButton.setImage(UIImage(named: "Stop"), for: .normal)
            } else {
                self.playButton.setImage(UIImage(named: "Play"), for: .normal)
            }
        }
    }
    var level: Level?
    var currentWorkbench: WorkbenchViewController? {
        didSet {
            if let appdelegate = UIApplication.shared.delegate as? AppDelegate {
                appdelegate.currentWorkBench = self.currentWorkbench
            }
        }
    }
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
    
    var codeRunner = CodeRunner()
    var _currentRequestUUID: String = ""

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    deinit {
        codeGeneratorService.cancelAllRequests()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        
        //MARK: SKView stuff
        // Load the SKScene from 'GameScene.sks'
        if let scene = SKScene(fileNamed: self.level?.customScene ?? "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            self.StuffView.presentScene(scene)
            
            self.level?.envyronmentSetup(scene)
        }
        self.StuffView.ignoresSiblingOrder = true
        self.StuffView.showsFPS = true
        self.StuffView.showsNodeCount = true
        
        //MARK: initialize Workbench
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
            if let toolboxFile = Bundle.main.path(forResource: self.level?.toolbox, ofType: nil) {
                // Load the XML from `toolbox.xml`
                let toolboxXML = try String(contentsOfFile: toolboxFile, encoding: String.Encoding.utf8)
                
                // Create a toolbox from the XML, using the blockFactory to create blocks declared in the XML
                let toolbox = try Toolbox.makeToolbox(xmlString: toolboxXML, factory: blockFactory)
                
                // Load the toolbox into the workbench
                try workbenchViewController.loadToolbox(toolbox)
            } else {
                print("Could not load toolbox with path '\(self.level?.toolbox ?? "NO PATH PROVIDED")'")
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
        
        //MARK: initialize the output handler for block code execution
        (UIApplication.shared.delegate as! AppDelegate).stuffDoer = JSHandler(view: self, scene: self.StuffView.scene!)
        
        //MARK: hint
        self.hintLabel.text = self.level?.hint
    }
    
    @IBAction func didPressPlayButton(_ sender: UIButton) {
        print("Play button was pressed")
        
        if self.isPlaying {
            self.isPlaying = false
            
            self.codeRunner.stopJavascriptCode()
        } else {
            self.isPlaying = true
            
            if let currentWorkbench = self.currentWorkbench {
                self.generateJavaScriptCode(forWorkbench: currentWorkbench) { error, code in
                    if error == nil {
                        //MARK: run code
                        if let code = code, code != "" {
                            // Run the JS code
                            self.codeRunner.runJavascriptCode(code, completion: {
                                self.currentWorkbench?.unhighlightAllBlocks()
                                
                                if self.isPlaying {
                                    print("CODE HAS FINIDHED RUNNING")
                                    //see if the execution was successful
                                    if let finished = self.level?.endTester(self.StuffView.scene!) {
                                        var alert = UIAlertController()
                                        if finished {
                                            //TODO stuff when finished
                                            self.level?.done = true
                                            
                                            alert = UIAlertController(title: "Congratulations!", message: "You've completed this level, ready for the next one?", preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                                            alert.addAction(UIAlertAction(title: "Next", style: .default, handler: { _ in
                                                self.navigationController?.popViewController(animated: true)
                                            }))
                                        } else {
                                            alert = UIAlertController(title: "Oops", message: "Looks like your code has finished running but you are not quite done, want to thy again?", preferredStyle: UIAlertControllerStyle.alert)
                                            alert.addAction(UIAlertAction(title: "Exit", style: .default, handler: { _ in
                                                self.navigationController?.popViewController(animated: true)
                                            }))
                                            alert.addAction(UIAlertAction(title: "Try again", style: .default, handler: { _ in
                                                self.level?.envyronmentSetup(self.StuffView.scene!)
                                            }))
                                        }
                                        
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                    self.isPlaying = false
                                } else {
                                    print("CODE WAS STOPPED FROM EXTERNAL SOURCES")
                                }
                            })
                        } else {
                            self.isPlaying = false
                            print("No code was provided")
                        }
                    }
                }
            } else {
                print("could not locate current workbech")
            }
        }
    }
    
    @IBAction func didPressExitButton(_ sender: Any) {
        self.exit()
    }
    
    @IBAction func didPressHideHintButton(_ sender: Any) {
        self.hintView.isHidden = true
    }
    
    @IBAction func didPressShowHintButton(_ sender: Any) {
        self.hintView.isHidden = false
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
    
    func saveWorkspace(completion: @escaping () -> Void) {
//        // Save the workspace to disk
//        if let workspace = self.currentWorkbench?.workspace {
//            do {
//                let xml = try workspace.toXML()
//                FileHelper.saveContents(xml, to: "workspace.xml")
//            } catch let error {
//                print("Couldn't save workspace to disk: \(error)")
//            }
//        }
        
        DispatchQueue.main.async {
            completion()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
    func exit() {
        self.saveWorkspace {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

enum CodeGenerationError: Error {
    case generationFailed(String)
}
