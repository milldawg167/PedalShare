//
//  Bike.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import CoreLocation

enum BikeType: String {
    case Road = "Road"
    case Mountain = "Mountain"
    case Hybrid = "Hybrid"
}

struct Bike {
    private var _id: String
    private var _type: BikeType
    private var _owner: String
    private var _details: String
    private var _currentLocation: CLLocationCoordinate2D
    
    var id: String {return _id}
    var type: BikeType {return _type}
    var owner: String {return _owner}
    var details: String {return _details}
    var currentLocation: CLLocationCoordinate2D {return _currentLocation}
    
    init(bikeID: String, bikeType: Int, bikeOwner: String,
         bikeDetails: String, bikeLocation: CLLocationCoordinate2D) {
        _id = bikeID
        _owner = bikeOwner
        _details = bikeDetails
        _currentLocation = bikeLocation
        
        switch bikeType {
        case 2:
            self._type = BikeType.Mountain
        default:
            self._type = BikeType.Road
        }
    }
}
