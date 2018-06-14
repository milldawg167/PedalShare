//
//  User.swift
//  PedalShare
//
//  Created by Andrew Miller on 14/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit

protocol User {
    var id: String { get }
    var name: String { get set }
    var email: String { get set }
}
