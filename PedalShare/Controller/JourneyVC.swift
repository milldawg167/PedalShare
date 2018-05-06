//
//  JourneyVC.swift
//  PedalShare
//
//  Created by Andrew Miller on 06/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class JourneyVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var directionsTableView: DirectionsTableView!
    
    var activityIndicator: UIActivityIndicatorView?
    var locationArray: [(textField: UITextField?, mapItem: MKMapItem?)]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        directionsTableView.contentInset = UIEdgeInsetsMake(-36, 0, -20, 0)
    }
    
    func addActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicator?.activityIndicatorViewStyle = .whiteLarge
        activityIndicator?.backgroundColor = view.backgroundColor
        activityIndicator?.startAnimating()
        view.addSubview(activityIndicator!)
    }
    
    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    func calculateSegmentDirections(index: Int) {
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = locationArray[index].mapItem
        request.destination = locationArray[index+1].mapItem
        request.requestsAlternateRoutes = true
        request.transportType = .automobile
        let directions = MKDirections(request: request)
        directions.calculate (completionHandler: {
            (response: MKDirectionsResponse?, error: Error?) in
            if let routeResponse = response?.routes {
                let quickestRouteForSegment = routeResponse.sort({$0.expectedTravelTime < $1.expectedTravelTime})[0]
            } else if let _ = error {
                let alert = UIAlertController(title: nil, message: "Directions not available.", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "OK", style: .cancel) { (alert) -> Void in
                    self.navigationController?.popViewController(animated: true)
                }
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    func plotPolyline(route: MKRoute) {
        mapView.addOverlay(route.polyline)
        if mapView.overlays.count == 1 {
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        } else {
            let polylineBoundingRect =  MKMapRectUnion(mapView.visibleMapRect, route.polyline.boundingMapRect)
            mapView.setVisibleMapRect(polylineBoundingRect, edgePadding: UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0), animated: false)
        }
    }
}

extension JourneyVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
    func mapView(mapView: MKMapView,
                 rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer! {
        
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if (overlay is MKPolyline) {
            if mapView.overlays.count == 1 {
                polylineRenderer.strokeColor = UIColor.blue.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 2 {
                polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(0.75)
            } else if mapView.overlays.count == 3 {
                polylineRenderer.strokeColor = UIColor.red.withAlphaComponent(0.75)
            }
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }
}
