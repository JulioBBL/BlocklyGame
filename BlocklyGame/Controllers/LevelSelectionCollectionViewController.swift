//
//  LevelSelectionCollectionViewController.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import UIKit

class LevelSelectionCollectionViewController: UICollectionViewController {
    var selectedLevel: Level?
    var levels: [Level] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Do any additional setup after loading the view.
        let levels = [Level(title: "Title 1",
                           description: "this is a description",
                           hints: ["this is a hint","and so is this"],
                           difficulty: .begginer,
                           steps: 7,
                           progress: 5),
                      Level(title: "Hello World",
                            description: "Oh, look, a description",
                            progress: 1),
                      Level()]
        self.levels.append(contentsOf: levels)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toChallengePreview" {
            (segue.destination as! PreviewViewController).level = self.selectedLevel!
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.levels.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let level = levels[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelCard", for: indexPath) as! ChallengeSelectCollectionViewCell
        
        cell.titleLabel.text = level.title
        cell.difficultyLabel.text = level.difficulty.rawValue
        cell.progressLabel.text = "\(level.progress)/\(level.steps)"
        cell.progressView.progress = Float(level.progress) / Float(level.steps)
        cell.colorDot.backgroundColor = level.progress == level.steps ? UIColor.emerald : UIColor.clear
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedLevel = levels[indexPath.row]
        self.performSegue(withIdentifier: "toChallengePreview", sender: self)
    }
    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
 
    }
    */
 
}
