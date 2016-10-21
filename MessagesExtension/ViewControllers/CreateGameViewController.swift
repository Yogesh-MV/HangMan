//
//  CreateGameViewController.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 10/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

class CreateGameViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, OptionsListViewCellDelegate {

    static let storyboardIdentifier = "CreateGameViewController"
    static let optionSection = 2
    
    @IBOutlet var hangWordLabel: UILabel!
    
    var optionsArray = [String]()
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "OptionsListViewCell", bundle: nil), forCellReuseIdentifier: OptionsListViewCell.cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Custom Action Methods

    @IBAction func doneButtonPressed(_ sender: AnyObject) {
    }
    
    
    // MARK: - Custom Methods

    func splitCharacters (string: String) {
        if  (string.characters.count) > 0 {
            optionsArray = (string.characters.map { String($0) })
        } else {
            optionsArray = []
        }
        tableView.reloadData()
        hangWordLabel.text = string

    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return optionsArray.count > 0 ? 5 : 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == CreateGameViewController.optionSection {
            return optionsArray.count > 0 ? 1 : 0
        }
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == CreateGameViewController.optionSection {
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionsListViewCell.cellIdentifier, for: indexPath) as! OptionsListViewCell
            cell.optionsListArray = optionsArray
            cell.updateOptionsView()
            cell.delegate = self
            return cell
        }

        return super.tableView(tableView, cellForRowAt: indexPath)
    }
    
    
    // MARK: - TextField view delegate
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        splitCharacters(string: textField.text!)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - OptionsList view delegate

    func removedWords(_ textArray: [NSInteger]) {
        var hangWord = ""
        for index in 0..<optionsArray.count {
            if !textArray.contains(index) {
                hangWord = hangWord.appending("\(optionsArray[index])")
            } else {
                hangWord = hangWord.appending(" _ ")
            }
        }

        hangWordLabel.text = hangWord
    }
    
}
