//
//  BikeAnnotation.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import MapKit

class BikeAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var bikeID: String
    var bikeType: String
    var bikeDetails: String
    var title: String?
    
    init(bike: Bike) {
        self.coordinate = bike.currentLocation
        self.bikeID = bike.id
        self.bikeType = bike.type
        self.bikeDetails = bike.details
        self.title = bike.type
    }
}
