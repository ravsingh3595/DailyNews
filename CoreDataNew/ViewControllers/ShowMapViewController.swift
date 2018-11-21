//
//  ShowMapViewController.swift
//  CoreDataNew
//
//  Created by Sonia Rani on 2018-11-20.
//  Copyright © 2018 RavSingh. All rights reserved.
//

import UIKit
import MapKit

class ShowMapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    var location = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
        centerMapOnLocation(location: initialLocation)
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // show artwork on map
        let annotation = MKPointAnnotation()  // <-- new instance here
        annotation.coordinate = self.location
        annotation.title = "Point"
        mapView.addAnnotation(annotation)
    }

    
}
