//
//  User.swift
//  twitter-project
//
//  Created by Eugene Posikyra on 19.07.2018.
//  Copyright © 2018 Eugene Posikyra. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let email: String
    
    init(authData: User) {
        uid = authData.uid
        email = authData.email
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
