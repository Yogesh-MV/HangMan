//
//  HangMessage.swift
//  HangMan
//
//  Created by Yogesh Murugesh on 01/11/16.
//  Copyright © 2016 Mallow Technologies Private Limited. All rights reserved.
//

import UIKit
import Messages

let kOriginalWord = "originalWord"
let kHangWord = "hangWord"
let kHintText = "hintText"
let kOptionCount = "optionCount"
let kGameStatus = "gameStatus"
let kGameWinner = "gameWinner"
let kGameInitiator = "gameInitiator"
let kStatusSuccess = "Completed"

class HangMessage: NSObject {

    var originalWord: String?
    var hangWord: String?
    var hintText: String?
    var removedCharactersArray: [String]?
    var removedCharactersString: String?
    var optionCount: Int?
    var selectedCOnversation: MSConversation?
    var isGameFinished: Bool = false
    var winnerUUID: String?
    var senderUUID: String?
    var currentUserUUID: String?

    override init() {
        
    }
        
    init(_ withConversation: MSConversation?) {
        selectedCOnversation = withConversation
        let urlComponents = NSURLComponents(url: (withConversation?.selectedMessage?.url)!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        self.currentUserUUID = withConversation?.localParticipantIdentifier.uuidString
        for item in queryItems! {
            let itemDetails = item as URLQueryItem
            if itemDetails.name == kHangWord {
                self.hangWord = itemDetails.value!
            } else if itemDetails.name == kHintText {
                self.hintText = itemDetails.value!
            } else if itemDetails.name == kOriginalWord {
                self.originalWord = itemDetails.value
            } else if itemDetails.name == kGameStatus {
                self.isGameFinished = itemDetails.value == kStatusSuccess ? true : false
            } else if itemDetails.name == kGameWinner {
                self.winnerUUID = itemDetails.value
            } else if itemDetails.name == kOptionCount {
                if let value = itemDetails.value {
                    self.optionCount = Int(value)
                } else {
                    self.optionCount = 1
                }
                
            } else if itemDetails.name == kGameInitiator {
                if let value = itemDetails.value {
                    self.senderUUID = value
                }
            } else {
                self.removedCharactersString = ""
                self.removedCharactersString = self.removedCharactersString?.appending(itemDetails.value!)
            }
        }
    }
    
    class func constructComponents(_ originalWord: String?,  _ hangWord: String?, _ hintText: String?,  _ removedCharacters: [String]?, _ optionCount: Int, _ senderId: String) -> URLComponents {
        
        let originalWordItem = URLQueryItem(name: kOriginalWord, value: originalWord)
        let hangWordItem = URLQueryItem(name: kHangWord, value: hangWord)
        let hintTextItem = URLQueryItem(name: kHintText, value: hintText)
        let optionCountItem = URLQueryItem(name: kOptionCount, value: String(describing: optionCount))
        let gameInitiatorItem = URLQueryItem(name: kGameInitiator, value: senderId)

        var queryItems = [URLQueryItem]()
        queryItems.append(optionCountItem)
        queryItems.append(originalWordItem)
        queryItems.append(hangWordItem)
        queryItems.append(hintTextItem)
        queryItems.append(gameInitiatorItem)

        var index = 0
        for missedCharacter in removedCharacters! {
            let missedItem = URLQueryItem(name: "missedItem\(index)", value: missedCharacter)
            index += 1
            queryItems.append(missedItem)
        }
        var components = URLComponents()
        components.queryItems = queryItems

        return components
    }
    
    func checkAndUpdateOptionCount(_ isIncrement: Bool) -> Bool {
        if isIncrement {
            if optionCount! < 1 {
                markGameAsFinished(senderUUID!)
                return false
            }
            optionCount = optionCount! - 1
            let optionCountItem = URLQueryItem(name: kOptionCount, value: String(describing: optionCount!))
            let urlComponents = NSURLComponents(url: (selectedCOnversation?.selectedMessage?.url)!, resolvingAgainstBaseURL: false)
            var queryItems = urlComponents?.queryItems
            queryItems?.removeFirst()
            queryItems?.insert(optionCountItem, at: 0)
            
            var components = URLComponents()
            components.queryItems = queryItems
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMessage"), object: components)
        }
        return true
    }
    
    func markGameAsFinished(_ winnerId: String) {
        let gameStatusItem = URLQueryItem(name: kGameStatus, value: kStatusSuccess)
        let gameWinnerItem = URLQueryItem(name: kGameWinner, value: winnerId)

        let urlComponents = NSURLComponents(url: (selectedCOnversation?.selectedMessage?.url)!, resolvingAgainstBaseURL: false)
        var queryItems = urlComponents?.queryItems
        queryItems?.append(gameStatusItem)
        queryItems?.append(gameWinnerItem)
        
        var components = URLComponents()
        components.queryItems = queryItems
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateMessage"), object: components)

    }
    
}
