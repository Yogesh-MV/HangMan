//
//  CreateGameViewController.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 10/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import Messages

protocol CreateGameViewControllerDelegate: class {
    func startConversation(_ controller: CreateGameViewController, _ messageLayout: MSMessageTemplateLayout, _ originalWord: String?,  _ removedCharacters: [String]?)
}


class CreateGameViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate, OptionsListViewCellDelegate {

    static let storyboardIdentifier = "CreateGameViewController"
    static let optionSection = 2
    weak var delegate: CreateGameViewControllerDelegate?

    @IBOutlet var hintText: UITextView!
    @IBOutlet var originalText: UITextField!
    @IBOutlet var hangWordLabel: UILabel!
    
    var optionsArray = [String]()
    var tempRandomArray = [NSInteger]()
    var removedCharacterArray = [String]()

    
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

    @IBAction func messageSendButtonPressed(_ sender: AnyObject) {
        
        if hintText.text.characters.count == 0 {
            //Show alert box
            return
        } else if (originalText.text?.characters.count)! == 0 {
            //Show alert box
            return
        }
        
        let messageLayout = MSMessageTemplateLayout()
        messageLayout.caption = hangWordLabel.text
        messageLayout.subcaption = hintText.text
        
        delegate?.startConversation(self, messageLayout, originalText.text, removedCharacterArray)
    }
    
    
    // MARK: - Custom Methods

    func splitCharacters (string: String) {
        if  (string.characters.count) > 0 {
            optionsArray = (string.characters.map { String($0) })
        } else {
            optionsArray = []
        }
        
        tempRandomArray = []
        let randomNumber = Int(arc4random_uniform(UInt32(optionsArray.count)))
        tempRandomArray.append(randomNumber)
        tableView.reloadData()
        finalHangWord(tempRandomArray)

    }
    
    func finalHangWord(_ textArray: [NSInteger]) {
        var hangWord = ""
        removedCharacterArray = []
        for index in 0..<optionsArray.count {
            if !textArray.contains(index) {
                hangWord = hangWord.appending("\(optionsArray[index])")
            } else {
                removedCharacterArray.append(optionsArray[index])
                hangWord = hangWord.appending(" _ ")
            }
        }
        
        hangWordLabel.text = hangWord
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
            cell.optionNeglectedArray = tempRandomArray
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
        finalHangWord(textArray)
    }
    
}
