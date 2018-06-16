
import UIKit
import MapKit

class JourneyVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    
    let locationManager = CLLocationManager()
    let authorizationStatus = CLLocationManager.authorizationStatus()
    let regionRadius: Double = 2000
    
    var activityIndicator: UIActivityIndicatorView?
    var passedJourney: Journey!
    var thejourney: Journey!
    
    func initData(forJourney journey: Journey) {
        self.passedJourney = journey
    }
    // MARK: - showRouteOnMap
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        configureLocationServices()
        thejourney = passedJourney
        showRouteOnMap(pickupCoordinate: thejourney.start!, destinationCoordinate: thejourney.end!)
    }
    
    func showRouteOnMap(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        
        let sourcePlacemark = MKPlacemark(coordinate: pickupCoordinate, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate, addressDictionary: nil)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let sourceAnnotation = MKPointAnnotation()
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        let destinationAnnotation = MKPointAnnotation()
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        let directionRequest = MKDirections.Request()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            let route = response.routes[0]
            
            self.mapView.addOverlay((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            var rect = MKCoordinateRegion.init(route.polyline.boundingMapRect)
            rect.span.latitudeDelta *= 1.5
            rect.span.longitudeDelta *= 1.5
            self.mapView.setRegion(rect, animated: true)
        }
    }
    
    func centerMapOnUserLocation() {
        guard let coordinate = locationManager.location?.coordinate else {return}
        let coordinateRegion = MKCoordinateRegion.init(center: coordinate, latitudinalMeters: regionRadius*2.0, longitudinalMeters: regionRadius*2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func addActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(frame: UIScreen.main.bounds)
        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.backgroundColor = view.backgroundColor
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }

    func hideActivityIndicator() {
        if activityIndicator != nil {
            activityIndicator?.removeFromSuperview()
            activityIndicator = nil
        }
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        
        renderer.strokeColor = UIColor(red: 17.0/255.0, green: 147.0/255.0, blue: 255.0/255.0, alpha: 1)
        
        renderer.lineWidth = 5.0
        
        return renderer
    }
}

extension JourneyVC: CLLocationManagerDelegate {
    func configureLocationServices() {
        if authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else {
            return
        }
    }
}







