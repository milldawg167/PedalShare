//
//  Owner.swift
//  PedalShare
//
//  Created by Andrew Miller on 14/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

struct Owner: User {
    private var _id: String
    
    var id: String {return _id}
    
    var name: String
    var email: String
    
    init(id: String, name: String, email: String) {
        _id = id
        self.name = name
        self.email = email
    }
}
