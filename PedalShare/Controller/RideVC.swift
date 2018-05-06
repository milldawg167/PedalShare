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

class RideVC: UIViewController {

    @IBOutlet weak var fromField: UITextField!
    @IBOutlet weak var toField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var goBtn: UIButton!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    var locationsArray: Array<CLLocationCoordinate2D>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        configureLocationServices()
        locationsArray = []
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
 
    @IBAction func goBtnPressed(_ sender: Any) {
        if fromField.text == "Current Location" {
            let coordinate = locationManager.location?.coordinate
            let lat_start = coordinate?.latitude
            let long_start = coordinate?.longitude
            let pair = CLLocationCoordinate2D(latitude: lat_start!, longitude: long_start!)
            locationsArray.append(pair)
            let pair2 = CLLocationCoordinate2D(latitude:  51.238255, longitude:  -0.604732)
            locationsArray.append(pair2)
        } else {
            let pair = CLLocationCoordinate2D(latitude: 51.24401, longitude: -0.58889)
            locationsArray.append(pair)
            geocode(textField: toField)
        }
        performSegue(withIdentifier: "big_map", sender: self)
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if fromField.text != nil && toField.text != nil {
            return true
        } else {
            showAlert("Please enter a valid starting point and destination.")
            return false
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let journeyVC = segue.destination as? JourneyVC {
            journeyVC.locationArray = locationsArray
        }
    }
    
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        print(alertString)
    }
    
    func geocode(textField: UITextField) {
        let geocoder = CLGeocoder()
        guard let postcode = textField.text else { return }
        // Create Address String
//        let address = "\(postcode)"
        let address = "8787 Snouffer School Rd, Montgomery Village, MD 20879"
        // Geocode Address String
//        geocoder.geocodeAddressString(address) { (placemarks, error) in
//            // Process Response
//            self.processResponse(withPlacemarks: placemarks, error: error)
//        }
        geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
            if((error) != nil){
                print("Error", error ?? "")
            }
            if let placemark = placemarks?.first {
                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                self.locationsArray.append(coordinates)
            }
        })
        goBtn.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) {
        // Update View
        goBtn.isHidden = false
        activityIndicator.stopAnimating()
        
        if let error = error {
            print("Unable to Forward Geocode Address (\(error))")
        } else {
            var location: CLLocation?
            
            if let placemarks = placemarks {
                location = placemarks.first?.location
                return
            }
            
            if let location = location {
                let coordinate = location.coordinate
                print(coordinate)
                locationsArray.append(coordinate)
            } else {
                print("Did not get coordinates")
                return
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



