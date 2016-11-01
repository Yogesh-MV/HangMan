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

class HangMessage: NSObject {

    var originalWord: String?
    var hangWord: String?
    var hintText: String?
    var removedCharactersArray: [String]?
    var removedCharactersString: String?

    override init() {
        
    }
        
    init(_ withConversation: MSConversation?) {
        let urlComponents = NSURLComponents(url: (withConversation?.selectedMessage?.url)!, resolvingAgainstBaseURL: false)
        let queryItems = urlComponents?.queryItems
        
        for item in queryItems! {
            let itemDetails = item as URLQueryItem
            if itemDetails.name == kHangWord {
                self.hangWord = itemDetails.value!
            } else if itemDetails.name == kHintText {
                self.hintText = itemDetails.value!
            } else if itemDetails.name == kOriginalWord {
                self.originalWord = itemDetails.value
            } else {
                self.removedCharactersString = self.removedCharactersString?.appending(itemDetails.value!)
            }
        }
    }
    
    class func constructComponents(_ originalWord: String?,  _ hangWord: String?, _ hintText: String?,  _ removedCharacters: [String]?) -> URLComponents {
        
        let originalWordItem = URLQueryItem(name: kOriginalWord, value: originalWord)
        let hangWordItem = URLQueryItem(name: kHangWord, value: hangWord)
        let hintTextItem = URLQueryItem(name: kHintText, value: hintText)
        
        var queryItems = [URLQueryItem]()
        queryItems.append(originalWordItem)
        queryItems.append(hangWordItem)
        queryItems.append(hintTextItem)
        
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
}
