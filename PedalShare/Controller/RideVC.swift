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
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 1000
    
    var locationTuples: [(textField: UITextField?, mapItem: MKMapItem?)]!
    var locationsArray: [(textField: UITextField?, mapItem: MKMapItem?)] {
        var filtered = locationTuples.filter({ $0.mapItem != nil })
        filtered += [filtered.first!]
        return filtered
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        configureLocationServices()
        
        locationTuples = [(fromField, nil), (toField, nil)]
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    func formatAddressFromPlacemark(placemark: CLPlacemark) -> String {
        return (placemark.postalCode!["FormattedAddressLines"] as! [String])
    }
 
    @IBAction func goBtnPressed(_ sender: Any) {
        if fromField.text != nil && toField.text != nil{
            performSegue(withIdentifier: "big_map", sender: self)
        } else {
            showAlert("Please enter a valid address")
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if locationTuples[0].mapItem == nil || locationTuples[1].mapItem == nil {
            showAlert("Please enter a valid starting point and destination.")
            return false
        } else {
            return true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let journeyVC = segue.destination as! JourneyVC
        journeyVC.locationArray = locationsArray
    }
    
    @IBAction func addressEntered(_ sender: UIButton) {
        view.endEditing(true)
        let currentTextField = locationTuples[sender.tag-1].textField
        CLGeocoder().geocodeAddressString(currentTextField!.text!, completionHandler: {(placemarks, error) -> Void in
            if let placemarks = placemarks {
                var addresses = [String]()
                for placemark in placemarks {
                    addresses.append(self.formatAddressFromPlacemark(placemark: placemark))
                }
                self.showAddressTable(addresses, textField:currentTextField!, placemarks:placemarks, sender:sender)
            } else {
                self.showAlert("Address not found.")
            }
        } )
    }
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK",
                                     style: .cancel) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
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
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(locations.last!, completionHandler: {(placemark: [CLPlacemark]?, error: Error?) -> Void in
            if let placemarks = placemarks {
                let placemark = placemarks[0]
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        centerMapOnUserLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}



