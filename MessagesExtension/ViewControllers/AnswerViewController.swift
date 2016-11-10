//
//  AnswerViewController.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 24/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import Messages

protocol AnswerViewControllerDelegate: class {
    func showSuccessView(_ controller: AnswerViewController)
    func showFailureView(_ controller: AnswerViewController)
}


class AnswerViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    static let storyboardIdentifier = "AnswerViewController"
    
    weak var delegate: AnswerViewControllerDelegate?

    @IBOutlet var hangWordLabel: UILabel!
    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!

    var selectedHangMessage: HangMessage?
    
    var optionsListArray = [String]()
    var missedCharactersArray: [(missedChar: String, postition: IndexPath)] = [(String, IndexPath)]()

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        randomString()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Custom Action Methods
    
    @IBAction func messageSendButtonPressed(_ sender: AnyObject) {
        if (selectedHangMessage?.checkAndUpdateOptionCount(true))! {
            if hangWordLabel.text == selectedHangMessage?.originalWord {
                //Show success screen and change the view
                selectedHangMessage?.markGameAsFinished((selectedHangMessage?.currentUserUUID)!)
                delegate?.showSuccessView(self)
            } else {
                //show wrong alert
                print("show wrong alert")
            }
        } else {
            //Show lose alert and change the view
            delegate?.showFailureView(self)
        }
    }
    

    // MARK: - Custom Method

    func randomString() {
        
        hangWordLabel.text = selectedHangMessage?.hangWord
        hintLabel.text = selectedHangMessage?.hintText
        
        let letters : NSString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomArray = [String]()
        
        let extraLength = letters.length / 3
        for index in 0 ..< extraLength {
            var nextChar = letters.character(at: Int(index))
            randomArray.append(NSString(characters: &nextChar, length: 1) as String)
        }
        
        let missedLetters : NSString = NSString(format: "%@", (selectedHangMessage?.removedCharactersString!)!)
        for index in 0 ..< missedLetters.length {
            var nextChar = missedLetters.character(at: Int(index))
            randomArray.append(NSString(characters: &nextChar, length: 1) as String)
        }

        optionsListArray = shuffled(array: randomArray)
        collectionView.reloadData()
    }
    
    func shuffled(array: [String]) -> [String] {
        var results = [String]()
        var indexes = (0 ..< array.count).map { $0 }
        while indexes.count > 0 {
            let indexOfIndexes = Int(arc4random_uniform(UInt32(indexes.count)))
            let index = indexes[indexOfIndexes]
            results.append(array[index])
            indexes.remove(at: indexOfIndexes)
        }
        return results
    }

    func checkExistingElemnt(element: (String, IndexPath)) -> Bool? {
        let filterArray = missedCharactersArray.filter {$0.missedChar == element.0 && $0.postition == element.1}
        return filterArray.count > 0 ? true : false
    }
    
    func elementAtIndex(element: (String, IndexPath)) -> Int? {
        let index = missedCharactersArray.index(where: { (elements) -> Bool in
            if elements.missedChar == element.0 && elements.postition == element.1 {
                return true
            } else {
                return false
            }
        })
        
        return index
    }
    
    
    // MARK:- CollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionCell.cellIdentifier, for: indexPath) as! OptionCollectionCell
        let optionValue = optionsListArray[indexPath.row]
        cell.textLabel.text = optionValue.localizedUppercase
        if (checkExistingElemnt(element: (optionValue, indexPath)))! {
            cell.backgroundColor = UIColor.lightGray
            let index =  elementAtIndex(element: (optionValue, indexPath))
            cell.orderLabel.text = String(format: "%d", index! + 1)
        } else {
            cell.orderLabel.text = ""
            cell.backgroundColor = UIColor.white
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionValue = optionsListArray[indexPath.row]
        if (checkExistingElemnt(element: (optionValue, indexPath)))! {
            missedCharactersArray.remove(at: elementAtIndex(element: (optionValue, indexPath))!)
        } else {
            if (selectedHangMessage?.removedCharactersString?.characters.count)! > missedCharactersArray.count {
                missedCharactersArray.append((optionValue, indexPath))
            }
        }

        collectionView.reloadData()
    }

}
