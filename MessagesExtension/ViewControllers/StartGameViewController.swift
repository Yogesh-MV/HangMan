//
//  StartGameViewController.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 11/10/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit

protocol StartGameViewControllerDelegate: class {
    func startGame(_ controller: StartGameViewController)
}

class StartGameViewController: UIViewController {

    static let storyboardIdentifier = "StartGameViewController"

    weak var delegate: StartGameViewControllerDelegate?

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Custom Action Methods

    @IBAction func startGameButtonPressed(_ sender: AnyObject) {
        delegate?.startGame(self)
    }

}
