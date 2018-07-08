//
//  FirebaseMessages.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 08.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

struct Twit {
    let text: String
    let userId: String
    //var createdAt = NSDate()
    let reference: DatabaseReference?
    
    init(text: String, userId: String) {
        self.text = text
        self.userId = userId
        self.reference = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        text = snapshotValue["text"] as! String
        userId = snapshotValue["userId"] as! String
        //createdAt = snapshotValue["createdAt"] as! NSDate
        reference = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["text": text, "userId": userId]
    }
}
