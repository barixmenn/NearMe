//
//  ViewController.swift
//  NearMe
//
//  Created by Baris on 24.12.2022.
//

import UIKit
import MapKit

class HomeVieController: UIViewController {
    
    var locationManager : CLLocationManager?
    
    //MARK: - UI Elements -
    lazy var mapView : MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
  
    lazy var searchTextField: UITextField = {
           let searchTextField = UITextField()
           searchTextField.layer.cornerRadius = 10
           searchTextField.returnKeyType = .go
           searchTextField.clipsToBounds = true
           searchTextField.backgroundColor = UIColor.white
           searchTextField.placeholder = "Search"
           searchTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
           searchTextField.leftViewMode = .always
           searchTextField.translatesAutoresizingMaskIntoConstraints = false
           return searchTextField
           
       }()
    
    
    //MARK: - LifeCycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestLocation()
        locationManager?.requestWhenInUseAuthorization()
        setupUI()
    }
    
    
    //MARK: - Functions -
    private func setupUI() {
        view.addSubview(mapView)
        view.addSubview(searchTextField)
        
        view.bringSubviewToFront(searchTextField)
        
        let constraints = [
            //MapView
            mapView.widthAnchor.constraint(equalTo: view.widthAnchor),
            mapView.heightAnchor.constraint(equalTo: view.heightAnchor),
            mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mapView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
           
            // add constraints to search text field
            searchTextField.heightAnchor.constraint(equalToConstant: 44),
            searchTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchTextField.widthAnchor.constraint(equalToConstant: view.bounds.size.width/1.2),
            searchTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 60),
            
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    
    private func checkLocationAuthorization () {
        guard let locationManager = locationManager,
              let location = locationManager.location else {return}
        
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 800, longitudinalMeters: 800)
            mapView.setRegion(region, animated: true)
        case .denied:
            print("Location services has been denied.")
        case .notDetermined, .restricted:
            print("Location cannot be determined or restricted.")
        @unknown default:
            print("Unknown error.")
        }
    }


}

extension HomeVieController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error")
    }
}
