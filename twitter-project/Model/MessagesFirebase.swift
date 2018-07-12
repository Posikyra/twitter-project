//
//  FirebaseMessages.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 08.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation
import FirebaseDatabase
var messagesFirebase = Array<MessagesFireBase>()


struct MessagesFireBase {
    let messageText: String!
    let messageId: Int
    let ref: DatabaseReference!
    
    
    init(messageText: String, messageId: Int) {
        self.messageText = messageText
        self.messageId = messageId
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        messageText = snapshotValue["messageText"] as! String
        messageId = snapshotValue["messageId"] as! Int
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["messageText": messageText, "messageId": messageId]
    }
}
