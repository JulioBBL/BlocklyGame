//
//  PreviewViewController.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    var challenge: Challenge?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        if let challenge = self.challenge {
            self.imageView.image = UIImage(named: challenge.imageName)
            self.titleLable.text = challenge.title
            self.difficultyLabel.text = challenge.difficulty.rawValue
            self.progressLabel.text = "\(challenge.progress)/\(challenge.steps)"
            self.descriptionText.text = challenge.description
        } else {
            print("couldn't find challenge info")
        }
        
        self.playButton.isEnabled = (self.challenge?.levels.filter({ $0.done == false }).count ?? 0 > 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! BlocklyViewController).level = self.challenge?.levels.first(where: { (level) -> Bool in
            return level.done == false
        })
    }

}
