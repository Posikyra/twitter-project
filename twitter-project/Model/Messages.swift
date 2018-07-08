//
//  Messages.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 04.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation
import RealmSwift
import Firebase
class Messages: Object {
    
    @objc dynamic var id = 0 ///сделай снова текст
    @objc dynamic var text = ""
    @objc dynamic var date: Date?
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    func IncrementaID() -> Int{
        let realm = try! Realm()
        return (realm.objects(Messages.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
}

