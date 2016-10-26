//
//  OptionCollectionCell.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 20/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class OptionCollectionCell: UICollectionViewCell {
    static let cellIdentifier = "OptionCollectionCellIdentifier"
    
    @IBOutlet var textLabel: UILabel!
    @IBOutlet var orderLabel: UILabel!

    override func awakeFromNib() {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 1.0
    }
}
