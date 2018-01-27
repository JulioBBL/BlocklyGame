//
//  ChallengeSelectionCollectionViewController.swift
//  BlocklyGame
//
//  Created by Julio Brazil on 21/01/18.
//  Copyright © 2018 Julio Brazil. All rights reserved.
//

import UIKit

class LevelSelectionCollectionViewController: UICollectionViewController {
    var selectedChallenge: Challenge?
    var challenges: [Challenge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = true

        // Do any additional setup after loading the view.
        let challenges: [Challenge] = [Challenge1(), Labirinth()]
        self.challenges.append(contentsOf: challenges)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toChallengePreview" {
            (segue.destination as! PreviewViewController).challenge = self.selectedChallenge!
        }
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.challenges.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let challenge = challenges[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "challengeCard", for: indexPath) as! ChallengeSelectCollectionViewCell
        
        cell.titleLabel.text = challenge.title
        cell.difficultyLabel.text = challenge.difficulty.rawValue
        cell.progressLabel.text = "\(challenge.progress)/\(challenge.steps)"
        cell.progressView.progress = Float(challenge.progress) / Float(challenge.steps)
        cell.colorDot.backgroundColor = challenge.progress == challenge.steps ? UIColor.emerald : UIColor.clear
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedChallenge = challenges[indexPath.row]
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
