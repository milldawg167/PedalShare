//
//  Journey.swift
//  PedalShare
//
//  Created by Andrew Miller on 12/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import CoreLocation

struct Journey {
    private var _start: CLLocationCoordinate2D?
    private var _end: CLLocationCoordinate2D?
    private var _user: String?
    private var _owner: String?
    private var _id: String?
    private var _bike: Bike?
    
    var start: CLLocationCoordinate2D? {return _start}
    var end: CLLocationCoordinate2D? {return _end}
    var user: String? {return _user}
    var owner: String? {return _owner}
    var id: String? {return _id}
    var bike: Bike? {return _bike}
    
    init(start_coords: CLLocationCoordinate2D, end_coords: CLLocationCoordinate2D,
         bikeUser: String, bikeOwner: String, bike: Bike) {
        _start = start_coords
        _end = end_coords
        _user = bikeUser
        _owner = bikeOwner
        _bike = bike
    }
}
