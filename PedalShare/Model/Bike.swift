//
//  Bike.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import CoreLocation

struct Bike {
    private var _id: String
    private var _type: String
    private var _owner: String
    private var _details: String
    private var _currentLocation: CLLocationCoordinate2D
    
    var id: String {return _id}
    var type: String {return _type}
    var owner: String {return _owner}
    var details: String {return _details}
    var currentLocation: CLLocationCoordinate2D {return _currentLocation}
    
    init(bikeID: String, bikeType: String, bikeOwner: String,
         bikeDetails: String, bikeLocation: CLLocationCoordinate2D) {
        _id = bikeID
        _type = bikeType
        _owner = bikeOwner
        _details = bikeDetails
        _currentLocation = bikeLocation
    }
}
