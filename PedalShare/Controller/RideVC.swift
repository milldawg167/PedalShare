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
    
    //var journey: Journey!
    
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
        
        let points = [CLLocationCoordinate2D(latitude: 51.2915, longitude: -0.4199),
                      CLLocationCoordinate2D(latitude: 51.281734, longitude: -0.407015),
                      CLLocationCoordinate2D(latitude: 51.281434, longitude: -0.406015),
                      CLLocationCoordinate2D(latitude: 51.2730, longitude: -0.3954)]
//        let tile = MKPolygon(coordinates: &points, count: points.count)
//        tile.title = "Moree"
//        mapView.add(tile)
        
        for point in points {
            let anno = BikeAnnotation(coordinate: point, ID: practiseID, type: "Road")
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
            btn.frame = CGRect(x:0, y:0, width:30, height:30)
            btn.setImage(UIImage(named: "map"), for: .normal)
            annotationView.rightCalloutAccessoryView = btn
            let detail = UILabel()
            detail.text = "Interesting stuff about bike \(anno.bikeID)"
            detail.numberOfLines = 2
//            detail.preferredMaxLayoutWidth = 40.0
            annotationView.detailCalloutAccessoryView = detail
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if let anno = view.annotation as? BikeAnnotation {
//            let place = MKPlacemark(coordinate: anno.coordinate)
//            let destination = MKMapItem(placemark: place)
//            destination.name = "Bike Location"
//            let regionDistance: CLLocationDistance = 1000
//            let regionSpan = MKCoordinateRegionMakeWithDistance(anno.coordinate, regionDistance, regionDistance)
//
//            let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span), MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking] as [String : Any]
//            MKMapItem.openMaps(with: [destination], launchOptions: options)
//        }
        if let anno = view.annotation as? BikeAnnotation {
            var journey = Journey()
            let start = locationManager.location?.coordinate
            print(start)
            journey.start_coords = start
            let end = anno.coordinate
            print(end)
            journey.end_coords = end
            guard let journeyVC = storyboard?.instantiateViewController(withIdentifier: "JourneyVC") as? JourneyVC else { return }
            journeyVC.initData(forJourney: journey)
            present(journeyVC, animated: true, completion: nil)
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "big_map" {
//            if let journeyVC = segue.destination as? JourneyVC {
//                journeyVC.journey = sender as? Journey
//            }
//        }
//    }
}

extension RideVC: MKMapViewDelegate {
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coordinate, regionRadius*2.0, regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//
//        if overlay.isKind(of: MKPolygon.self) {
//            let renderer = MKPolygonRenderer(overlay: overlay)
//
//            renderer.fillColor = UIColor.cyan.withAlphaComponent(0.2)
//            renderer.strokeColor = UIColor.blue.withAlphaComponent(0.7)
//            renderer.lineWidth = 3
//            return renderer
//        }
//        fatalError()
//    }
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



