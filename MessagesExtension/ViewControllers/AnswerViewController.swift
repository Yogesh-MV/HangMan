//
//  AnswerViewController.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 24/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    static let storyboardIdentifier = "AnswerViewController"

    @IBOutlet var hangWordLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var missedString : String?
    var hangWordString : String?
    var hintTextString : String?

    var optionsListArray = [String]()
    var missedCharactersArray = [String]()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        randomString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Method

    func randomString() {
        
        hangWordLabel.text = hangWordString
        hintLabel.text = hintTextString
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomArray = [String]()
        
        let extraLength = letters.length / 3
        for _ in 0 ..< extraLength {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomArray.append(NSString(characters: &nextChar, length: 1) as String)
        }
        
        let missedLetters : NSString = NSString(format: "%@", missedString!)
        let missedLen = UInt32(missedLetters.length / 2)
        
        for _ in 0 ..< missedLetters.length {
            let rand = arc4random_uniform(missedLen)
            var nextChar = missedLetters.character(at: Int(rand))
            randomArray.append(NSString(characters: &nextChar, length: 1) as String)
        }

        optionsListArray = randomArray
        collectionView.reloadData()
    }
    
    
    // MARK:- CollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionCell.cellIdentifier, for: indexPath) as! OptionCollectionCell
        let optionValue = optionsListArray[indexPath.row]
        cell.textLabel.text = optionValue
        if (missedCharactersArray.contains(optionValue)) {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionValue = optionsListArray[indexPath.row]
        if missedCharactersArray.contains(optionValue) {
            missedCharactersArray.remove(at: missedCharactersArray.index(of: optionValue)!)
        } else {
            if (missedString?.characters.count)! > missedCharactersArray.count {
                missedCharactersArray.append(optionValue)
            }
        }
        collectionView.reloadData()
    }

}
