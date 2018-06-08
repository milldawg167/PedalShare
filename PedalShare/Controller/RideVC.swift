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
        goBtn.isHidden = true
        activityIndicator.startAnimating()
        if fromField.text == "" {
            let coordinate = locationManager.location?.coordinate
            let lat_start = coordinate?.latitude
            let long_start = coordinate?.longitude
            let pair = CLLocationCoordinate2D(latitude: lat_start!, longitude: long_start!)
            locationsArray.append(pair)
            geocode(textField: toField)
            goBtn.isHidden = false
            activityIndicator.stopAnimating()
            if !goBtn.isHidden {
                performSegue(withIdentifier: "big_map", sender: self)
            } else {
                print("error here!!!!")
            }
        } else {
            let pair = CLLocationCoordinate2D(latitude: 51.24401, longitude: -0.58889)
            locationsArray.append(pair)
            // geocode(textField: toField)
        }
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
    
    func geocode(textField: UITextField) {
        let geocoder = CLGeocoder()
        let address = textField.text
        geocoder.geocodeAddressString(address!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Error: \(String(describing: error))")
            }

            if let placemark = placemarks?.first {
                let lat_end = placemark.location!.coordinate.latitude
                let long_end = placemark.location!.coordinate.longitude
                print("Lat: \(lat_end) -- Long: \(long_end)")
                let pair2 = CLLocationCoordinate2D(latitude: lat_end, longitude: long_end)
                self.locationsArray.append(pair2)
                print("\(self.locationsArray)")
                return
            } else {
                print("\(String(describing: error))")
            }
        })
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



