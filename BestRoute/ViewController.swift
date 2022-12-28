//
//  ViewController.swift
//  BestRoute
//
//  Created by Julia Semyzhenko on 21.12.2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var routeButton: UIButton!
    
    var annotationsArray = [MKPointAnnotation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func addAdressPressed(_ sender: UIButton) {
        addAddressAlert(title: "Add your address", placeholder: "Start typing here") { [self] (text) in
            placemarkManager(newAdress: text)
        }
    }
    
    @IBAction func routePressed(_ sender: UIButton) {
        
        for index in 0...annotationsArray.count - 2 {
            createDirectionRequest(startCoordination: annotationsArray[index].coordinate, destinationCoordination: annotationsArray[index + 1].coordinate)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        mapView.removeOverlays(mapView.overlays)
        mapView.removeAnnotations(mapView.annotations)
        annotationsArray = [MKPointAnnotation]()
        routeButton.isHidden = true
        resetButton.isHidden = true
    }
    
    private func placemarkManager(newAdress: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(newAdress) { [self] (placemark, error) in
            if let error = error {
                print(error)
                errorAlert(title: "Error", message: "Wrong address. Try to make another request.")
                return
            }
            guard let placemark = placemark else { return }
            let firstPlacemark = placemark.first
            
            
            let annotation = MKPointAnnotation()
            annotation.title = "\(newAdress)"
            
            guard let placemarkLocation = firstPlacemark?.location else { return }
            annotation.coordinate = placemarkLocation.coordinate
            annotationsArray.append(annotation)
            
            if annotationsArray.count > 2 {
                resetButton.isHidden = false
                routeButton.isHidden = false
            }
            mapView.showAnnotations(annotationsArray, animated: true)
        }
    }
    
    private func createDirectionRequest(startCoordination: CLLocationCoordinate2D, destinationCoordination: CLLocationCoordinate2D) {
        let starLocation = MKPlacemark(coordinate: startCoordination)
        let destinationLocation = MKPlacemark(coordinate: destinationCoordination)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: starLocation)
        request.destination = MKMapItem(placemark: destinationLocation)
        request.transportType = .walking
        request.requestsAlternateRoutes = true
        
        let direction = MKDirections(request: request)
        direction.calculate { (responce, error) in
            
            if let error = error {
                print(error)
                return
            }
            guard let responce = responce else {
                self.errorAlert(title: "Error", message: "This route is not available")
                return
            }
            var minRoute = responce.routes[0]
            for route in responce.routes {
                minRoute = (route.distance < minRoute.distance) ? route : minRoute
            }
            self.mapView.addOverlay(minRoute.polyline)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = .darkGray
        return renderer
    }
}
