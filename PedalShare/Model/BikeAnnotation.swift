//
//  BikeAnnotation.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import Foundation
import MapKit

class BikeAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var bikeID: String
    var bikeType: String
    var title: String?

    var bik = Bike()
    
    init(currentLocation: CLLocationCoordinate2D, bikeID: String, bikeType: String) {
        self.bike.coordinate = currentLocation
        self.bike.id = bikeID
        self.bike.type = bikeType
        self.title = bikeType}
}
