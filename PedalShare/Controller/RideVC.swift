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

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 2000
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = true
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        configureLocationServices()
        //addDoubleTap()
        
        let bikes = bikeArray
        for bike in bikes {
            let anno = BikeAnnotation(bike: bike)
            self.mapView.addAnnotation(anno)
        }
    }
    
    @IBAction func unwindToRideVC(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoIdentifier = "Bike"
        var annotationView: MKAnnotationView?
        if annotation.isKind(of: MKUserLocation.self) {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "User")
//            annotationView?.image = UIImage(named: "directions_icon")
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        if let annotationView = annotationView, let anno = annotation as? BikeAnnotation {
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "\(anno.bikeType)")
            let btn = UIButton()
            btn.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn.setImage(UIImage(named: "map"), for: UIControl.State.normal)
            annotationView.rightCalloutAccessoryView = btn
            let detail = UILabel()
            detail.text = "\(anno.bikeDetails)"
            detail.numberOfLines = 2
            annotationView.detailCalloutAccessoryView = detail
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? BikeAnnotation {
            mapView.deselectAnnotation(anno, animated: false)
            let start = (locationManager.location?.coordinate)!
            let end = anno.coordinate
            let journey = Journey(start_coords: start, end_coords: end, bikeUser: user, bikeOwner: owner, bike: bike1)
            guard let journeyVC = storyboard?.instantiateViewController(withIdentifier: "JourneyVC") as? JourneyVC else { return }
            journeyVC.initData(forJourney: journey)
            present(journeyVC, animated: true, completion: nil)
        }
    }
    
//    func mapView(mapView: MKMapView, didSelectAnnotationView view:MKAnnotationView) {
//        let tapGesture = UITapGestureRecognizer(target:self,  action:#selector(calloutTapped(sender:)))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
//        view.removeGestureRecognizer(view.gestureRecognizers!.first!)
//    }
//
//    @objc func calloutTapped(sender:UITapGestureRecognizer) {
//        let view = sender.view as! MKAnnotationView
//        if let annotation = view.annotation as? MKPointAnnotation {
//            performSegue(withIdentifier: "annotationDetailSegue", sender: annotation)
//        }
//    }
    
    func showAlert(_ alertString: String) {
        let alert = UIAlertController(title: nil, message: alertString, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default) { (alert) -> Void in
        }
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
        print(alertString)
    }
}

extension RideVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius*2.0, longitudinalMeters: regionRadius*2.0)
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



