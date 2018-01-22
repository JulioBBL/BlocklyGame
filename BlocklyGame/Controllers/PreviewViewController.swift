//
//  PreviewViewController.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    var level: Level?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let level = self.level {
            self.imageView.image = UIImage(named: level.imageName)
            self.titleLable.text = level.title
            self.difficultyLabel.text = level.difficulty.rawValue
            self.progressLabel.text = "\(level.progress)/\(level.steps)"
            self.descriptionText.text = level.description
        } else {
            print("couldn't find level info")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! BlocklyViewController).level = self.level
    }

}
