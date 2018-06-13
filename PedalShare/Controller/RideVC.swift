//
//  RideVC.swift
//  PedalShare
//
//  Created by Andrew Miller on 05/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class RideVC: UIViewController{

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    var journey: Journey!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        configureLocationServices()
        journey = Journey()
    }
    
    @IBAction func unwindToRideVC(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
 
    @IBAction func goBtnPressed(_ sender: UIButton) {
//        goBtn.isHidden = true
//        activityIndicator.startAnimating()
//        if fromField.text == "" {
        let start_coord = locationManager.location?.coordinate
        let geocoder = CLGeocoder()
        let address = self.fromField.text
        if (address != nil) {print(address)}
        self.journey.start_coords = start_coord
        geocoder.geocodeAddressString("\(address)", completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {print("ADM: \(String(describing: error))")}
            
            if let placemark = placemarks?.first {
                let end = placemark.location?.coordinate
                print(end)
                self.journey.end_coords = end
            } else {
                print("\(String(describing: error))")
            }
        })
        print("\(journey.end_coords)")
        
        self.performSegue(withIdentifier: "big_map", sender: journey)
//        goBtn.isHidden = false
//        activityIndicator.stopAnimating()
//        print("\(locationsArray)")
//        if !goBtn.isHidden {
//                performSegue(withIdentifier: "big_map", sender: self)
//        } else {print("error here!!!!")}
//        } else {
//            let pair = CLLocationCoordinate2D(latitude: 51.24401, longitude: -0.58889)
//            locationsArray.append(pair)
//            // geocode(textField: toField)
//        }
        // let pair2 = CLLocationCoordinate2D(latitude:  51.238255, longitude:  -0.604732)
        // locationsArray.append(pair2)
    }
    
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        print(alertString)
    }
    
//    func geocode(textField: UITextField, coordinates: Array<CLLocationCoordinate2D>) -> Array<CLLocationCoordinate2D> {
//
//        return coord_array
//    }
    
//    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
//        if toField.text != nil {
//            return true
//        } else {
//            showAlert("Please enter a valid starting point and destination.")
//            return false
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "big_map" {
            if let journeyVC = segue.destination as? JourneyVC {
                journeyVC.journey = sender as? Journey
            }
        }
    }
}

extension RideVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension RideVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



