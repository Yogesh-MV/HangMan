//
//  OptionsListViewCell.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 20/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

protocol OptionsListViewCellDelegate: class {
    func removedWords(_ textArray: [NSInteger])
}

class OptionsListViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    static let cellIdentifier = "OptionsListViewCellIdentifier"
    weak var delegate: OptionsListViewCellDelegate?

    @IBOutlet var collectionView: UICollectionView!
    
    var optionNeglectedArray = [NSInteger]()
    var optionsListArray = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.register(UINib(nibName: "OptionCollectionCell", bundle: nil), forCellWithReuseIdentifier: OptionCollectionCell.cellIdentifier)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateOptionsView () {
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
        if optionNeglectedArray.contains(indexPath.row) {
            cell.backgroundColor = UIColor.lightGray
        } else {
            cell.backgroundColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let optionValue = indexPath.row
        if (optionNeglectedArray.contains(indexPath.row)) {
            let index = (optionNeglectedArray).index(of: optionValue)
            optionNeglectedArray.remove(at: index!)
        } else {
            optionNeglectedArray.append(optionValue)
        }
        
        collectionView.reloadData()
        
        delegate?.removedWords(optionNeglectedArray)
    }
    
}
