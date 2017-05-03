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
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var aboveTableView           : UIView!
    @IBOutlet weak var moreStationsinfoButton   : UIButton!
    @IBOutlet weak var mapView                  : UIView!
    
    var defaultTableViewFrame                   : CGRect?
    var defaultAboveTableViewFrame              : CGRect?
    var defaultSortViewFrame                    : CGRect?
    var moreInfoIsOpened                        = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTableViewFrame        = tableView.frame
        defaultAboveTableViewFrame   = aboveTableView.frame
        defaultSortViewFrame         = sortView.frame
        
        setBarButtons()
        configurateMap()
        aboveTableView.layer.cornerRadius = 10
        aboveTableView.addShadow(opacity: 3, radius: 2)
        moreStationsinfoButton.layer.cornerRadius = 10
        
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
    
    func configurateMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 55.75, longitude: 37.62, zoom: 11.0)
        let mapViewGoogle = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        mapViewGoogle.isMyLocationEnabled = true
        mapView.addSubview(mapViewGoogle)
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 55.75, longitude: 37.62)
        marker.title = "Moscow"
        marker.snippet = "Russia"
        marker.map = mapViewGoogle
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
   
    func setBarButtons() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settings))
        settingsButton.tintColor = UIColor(red: 34/255, green: 163/255, blue: 236/255, alpha: 1)
        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(profile))
        profileButton.tintColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem  = profileButton
        
    }
    
    //MARK: Actions
    
    @IBAction func openMore(_ sender: UIButton) {
        if moreInfoIsOpened {
            UIView.animate(withDuration: 0.3, animations: {
                
            })
            UIView.animate(withDuration: 0.3, animations: {
                self.aboveTableView.frame         = self.defaultAboveTableViewFrame!
                self.tableView.frame              = self.defaultTableViewFrame!
                self.sortView.frame               = self.defaultSortViewFrame!
            }, completion: { (success) in
                self.moreInfoIsOpened = false
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                let slideConstant : CGFloat = (72*3)
                self.aboveTableView.frame.origin.y -= slideConstant
                self.sortView.frame.origin.y       -= slideConstant
                self.tableView.frame = CGRect(x: 0, y: self.tableView.frame.origin.y - slideConstant, width: self.tableView.frame.width, height: self.tableView.frame.height + slideConstant)
            }, completion: { (success) in
                self.moreInfoIsOpened = true
            })
        }
    }
    
    
    func settings(){
        
    }
    func profile() {
        
    }
    
    
    
    
}

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.backgroundColor = UIColor.red
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
}

