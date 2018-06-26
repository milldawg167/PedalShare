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

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var pullUpViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pullUpView: UIView!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 2000
    
    var screenSize = UIScreen.main.bounds
    var searchBar = UISearchBar()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(RideVC.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RideVC.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.searchBar.delegate = self
        
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsPointsOfInterest = true
        
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        
        animateViewDown()
        configureLocationServices()
        //addDoubleTap()
        
        let bikes = bikeArray
        for bike in bikes {
            let anno = BikeAnnotation(bike: bike)
            self.mapView.addAnnotation(anno)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func unwindToRideVC(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    @IBAction func centerMapBtnWasPressed(_ sender: Any) {
        if authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse {
            centerMapOnUserLocation()
        }
    }
    
    @IBAction func allBtnPressed(_ sender: Any) {
        for annotation in mapView.annotations {
            mapView.view(for: annotation)?.isHidden = false
        }
    }
    
    @IBAction func roadBtnPressed(_ sender: Any) {
        for annotation in mapView.annotations {
            if !annotation.isKind(of: MKUserLocation.self) && !(annotation.title == "Road") {
                mapView.view(for: annotation)?.isHidden = true
            } else {
                mapView.view(for: annotation)?.isHidden = false
            }
        }
    }
    
    @IBAction func mountainBtnPressed(_ sender: Any) {
        for annotation in mapView.annotations {
            if !annotation.isKind(of: MKUserLocation.self) && !(annotation.title == "Mountain") {
                mapView.view(for: annotation)?.isHidden = true
            } else {
                mapView.view(for: annotation)?.isHidden = false
            }
        }
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }

    func addSwipeDown() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(animateViewDown))
        swipe.direction = .down
        pullUpView.addGestureRecognizer(swipe)
    }
    
    func animateViewUp() {
        pullUpViewHeightConstraint.constant = 60
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateViewDown() {
        centerMapOnUserLocation()
        pullUpViewHeightConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RideVC.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addSearchBar() {
        searchBar.frame = CGRect(x: 10, y: 10, width: (screenSize.width - 20), height: 40)
        searchBar.tintColor = .gray
        pullUpView.addSubview(searchBar)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annoIdentifier = "Bike"
        var annotationView: MKAnnotationView?
        if !annotation.isKind(of: MKUserLocation.self) {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annoIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        } else if let deqAnno = mapView.dequeueReusableAnnotationView(withIdentifier: annoIdentifier) {
            annotationView = deqAnno
            annotationView?.annotation = annotation
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
    
    func getDirections(from source: CLLocationCoordinate2D, to destination: MKMapItem) {
        let sourceMapItem = MKMapItem(placemark: MKPlacemark(coordinate: source))
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        
        print("Made it here")
        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { (response, _) in
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
//            self.mapView.addOverlay(primaryRoute.polyline)
            self.mapView.addOverlay((primaryRoute.polyline), level: MKOverlayLevel.aboveRoads)
            
            self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
//            self.steps = primaryRoute.steps
//            for i in 0 ..< primaryRoute.steps.count {
//                let step = primaryRoute.steps[i]
//                print(step.instructions)
//                print(step.distance)
//                let region = CLCircularRegion(center: step.polyline.coordinate,
//                                              radius: 20,
//                                              identifier: "\(i)")
//                self.locationManager.startMonitoring(for: region)
//                let circle = MKCircle(center: region.center, radius: region.radius)
//                self.mapView.addOverlay(circle)
//            }
//
//            let initialMessage = "In \(self.steps[0].distance) meters, \(self.steps[0].instructions) then in \(self.steps[1].distance) meters, \(self.steps[1].instructions)."
//            self.directionsLabel.text = initialMessage
//            let speechUtterance = AVSpeechUtterance(string: initialMessage)
//            self.speechSynthesizer.speak(speechUtterance)
//            self.stepCounter += 1
        }
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let anno = view.annotation as? BikeAnnotation {
            mapView.deselectAnnotation(anno, animated: false)
            let start = (locationManager.location?.coordinate)!
            let end = anno.coordinate
            let journey = Journey(start_coords: start, end_coords: end, bikeRider: rider1, bikeOwner: owner1, bike: bike1)
//            guard let journeyVC = storyboard?.instantiateViewController(withIdentifier: "JourneyVC") as? JourneyVC else { return }
//            journeyVC.initData(forJourney: journey)
//            present(journeyVC, animated: true, completion: nil)
            for annotation in mapView.annotations {
                mapView.view(for: annotation)?.isHidden = false
            }
            centerMapOnAnnotation(annotation: anno)
            animateViewUp()
            addSwipeDown()
            addSearchBar()
            hideKeyboardWhenTappedAround()
        }
    }
}

extension RideVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
//        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
//        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.start { (response, _) in
            guard let response = response else { return }
            guard let firstMapItem = response.mapItems.first else { return }
            self.getDirections(from: CLLocationCoordinate2D(latitude: 51.5335, longitude: -0.346729), to: firstMapItem)
        }
    }
}

extension RideVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius*2.0, longitudinalMeters: regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func centerMapOnAnnotation(annotation: MKAnnotation) {
        guard let anno = annotation as? BikeAnnotation else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: anno.coordinate, latitudinalMeters: regionRadius*2.0, longitudinalMeters: regionRadius*2.0)
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



