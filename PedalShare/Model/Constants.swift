//
//  Constants.swift
//  PedalShare
//
//  Created by Andrew Miller on 13/06/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import CoreLocation

let PedalShareGreen = UIColor(displayP3Red: 76.0/255.0, green: 175.0/255.0, blue: 80.0/255.0, alpha: 1.0)

let owner1 = Owner(id: "ABCD1234", name: "Andrew Miller", email: "am01968@surrey.ac.uk")
let rider1 = Rider(id: "WXYZ1324", name: "Luke Lomas", email: "luke.lomas@gmail.com", bike: bike1)

let bike1 = Bike(bikeID: "ABCD1234", bikeType: "Road", bikeOwner: owner1, bikeDetails: "Whistler Orange", bikeLocation: CLLocationCoordinate2D(latitude: 51.2915, longitude: -0.4199))
let bike2 = Bike(bikeID: "ABCD1235", bikeType: "Road", bikeOwner: owner1, bikeDetails: "Orbea Yellow", bikeLocation: CLLocationCoordinate2D(latitude: 51.281734, longitude: -0.407015))
let bike3 = Bike(bikeID: "ABCD1236", bikeType: "Mountain", bikeOwner: owner1, bikeDetails: "Specialised LightGray", bikeLocation: CLLocationCoordinate2D(latitude: 51.281434, longitude: -0.406015))
let bike4 = Bike(bikeID: "ABCD1237", bikeType: "Mountain", bikeOwner: owner1, bikeDetails: "Specialised LightGray", bikeLocation: CLLocationCoordinate2D(latitude: 51.2730, longitude: -0.3954))

let bikeArray = [bike1,bike2,bike3,bike4]
