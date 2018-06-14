//
//  Rider.swift
//  PedalShare
//
//  Created by Andrew Miller on 14/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

struct Rider: User {
    private var _id: String
    private var _bike: Bike
    
    var id: String {return _id}
    var bike: Bike {return _bike}
    
    var name: String
    var email: String
    
    init(id: String, name: String, email: String, bike: Bike) {
        _id = id
        _bike = bike
        self.name = name
        self.email = email
    }
}
