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
    
    init(coordinate: CLLocationCoordinate2D, ID: String, type: String) {
        self.coordinate = coordinate
        self.bikeID = ID
        self.bikeType = type
        self.title = type
    }
}
