//
//  AmazingSketchMapViewController.swift
//  AmazingSketch
//
//  Created by Pavel Boryseiko on 12/10/2016.
//  Copyright © 2016 Pavel Boryseiko. All rights reserved.
//

import UIKit
import MapKit

class AmazingSketchMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var setHandler: AmazingSketchSetHandler?
    
    private var locationManager = CLLocationManager()
    private var firstRender = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .Hybrid
        
        let setButton = UIBarButtonItem(title: "Set", style: .Plain, target: self, action: #selector(mapDoneHandler))
        let typeButton = UIBarButtonItem(title: "Terrain Type", style: .Plain, target: self, action: #selector(typeHandler))
        
        self.navigationItem.rightBarButtonItems = [setButton, typeButton]
    }

    
    
    //MARK: map callbakcs
    
    @objc private func mapDoneHandler(button: UIBarButtonItem) {
        if let image = mapView.renderToImage() {
            setHandler?(image: image)
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @objc private func typeHandler(button: UIBarButtonItem) {
        switch mapView.mapType {
        case .Standard:
            mapView.mapType = .Satellite
        case .Satellite:
            mapView.mapType = .Hybrid
        case .Hybrid:
            mapView.mapType = .Standard
        default:
            break
        }
    }
    
    //MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if firstRender {
            let region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
            mapView.setRegion(region, animated: true)
            firstRender = false
        }
    }
    
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        let view = mapView.viewForAnnotation(mapView.userLocation)
        view?.hidden = true
    }
    
    //MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {

    }
}
