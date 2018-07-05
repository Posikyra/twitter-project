//
//  Messages.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 04.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation
import RealmSwift

class Messages: Object {
    
    @objc dynamic var id = ""
    @objc dynamic var text = ""
    @objc dynamic var date: Date?
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
