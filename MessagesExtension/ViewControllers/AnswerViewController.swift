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
    @IBOutlet var collectionView: UICollectionView!

    var optionsListArray = [String]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK:- CollectionView DataSource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionsListArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCollectionCell.cellIdentifier, for: indexPath) as! OptionCollectionCell
        let optionValue = optionsListArray[indexPath.row]
        cell.textLabel.text = optionValue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }

}
