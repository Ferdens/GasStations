//
//  ViewController.swift
//  GasStations
//
//  Created by anton Shepetuha on 02.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {
    
    var gradientView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBarButtons()

    }
    override func viewWillAppear(_ animated: Bool) {
        displayView()
        setSearchView()
    }
    
    func setSearchView(){
        let searchBar = UISearchBar(frame: CGRect(x: self.view.bounds.width * 0.05, y: gradientView.frame.maxY - 20, width: self.view.frame.width * 0.9, height: 40))
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        self.view.addSubview(searchBar)
    }
    func settings(){
        
    }
    func profile() {
        
    }
    
    func displayView(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.15)
        var colors = [UIColor]()
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.95))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.95))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.85))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.75))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.65))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.55))
        colors.append(UIColor(red: 19/255, green: 51/255, blue: 64/255, alpha: 0.45))
        gradientView.applyGradient(colors,[0.2,0.3,0.5,0.7,0.8,0.9,1])
        self.view.addSubview(gradientView)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    func setBarButtons() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settings))
        settingsButton.tintColor = UIColor(red: 34/255, green: 163/255, blue: 236/255, alpha: 1)
        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(profile))
        profileButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem  = profileButton
        
    }
    
    
    
    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 55.75, longitude: 37.62, zoom: 11.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.62)
        marker.title = "Moscow"
        marker.snippet = "Russia"
        marker.map = mapView
    }
    
}

