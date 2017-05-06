//
//  ViewController.swift
//  GasStations
//
//  Created by anton Shepetuha on 02.05.17.
//  Copyright © 2017 anton Shepetuha. All rights reserved.
//

import UIKit
import GoogleMaps

private let slideConstant : CGFloat = 60*3
class ViewController: UIViewController, GMSMapViewDelegate {
    
    var gradientView = UIView()
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var tableView                : UITableView!
    @IBOutlet weak var aboveTableView           : UIView!
    @IBOutlet weak var moreStationsinfoButton   : UIButton!
    @IBOutlet weak var mapView                  : UIView!
    @IBOutlet weak var sortByPrice              : UIButton!
    @IBOutlet weak var sortByRange              : UIButton!
    
    var defaultTableViewFrame                   : CGRect?
    var defaultAboveTableViewFrame              : CGRect?
    var defaultSortViewFrame                    : CGRect?
    var currentTableViewFrame                   : CGRect?
    var currentAboveTableViewFrame              : CGRect?
    var currentSortViewFrame                    : CGRect?
    var mapViewGoogle                           : GMSMapView!
    var moreInfoIsOpened                        = false
    var smallCornerView                         : UIView!
    
    var gasStations = DataManager.shared.gasStations
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultTableViewFrame        = tableView.frame
        defaultAboveTableViewFrame   = aboveTableView.frame
        defaultSortViewFrame         = sortView.frame
        setBarButtons()
        configurateMap()
        
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        //        self.view.addGestureRecognizer(tapGesture)
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.aboveTableView.addGestureRecognizer(gestureRecognizer)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.sortView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.sortView.addGestureRecognizer(swipeLeft)
        
        smallCornerView = UIView(frame: CGRect.init(x: sortByRange.frame.midX, y: sortByRange.frame.maxY - 5, width: 10, height: 10))
        smallCornerView.backgroundColor = sortByRange.backgroundColor
        smallCornerView.transform = CGAffineTransform.init(rotationAngle: CGFloat(Double.pi/4))
        sortByRange.addSubview(smallCornerView)
        sortByRange.bringSubview(toFront: smallCornerView)
        
    }
    
    //MARK: Drag stack
    func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if gestureRecognizer.state == .cancelled || gestureRecognizer.state == .ended {
            
            let middle = (self.defaultAboveTableViewFrame?.origin.y)! - (slideConstant/2)
            if (currentAboveTableViewFrame?.origin.y)! >= middle {
                tableViewDefaultSize(true)
                } else {
                tableViewBigerSize(true)

            }
        }
        if gestureRecognizer.state == .began || gestureRecognizer.state == .changed {
            
            let translation = gestureRecognizer.translation(in: self.view)
            // note: 'view' is optional and need to be unwrapped
            
            if (gestureRecognizer.view!.frame.origin.y + translation.y) > (self.defaultAboveTableViewFrame?.origin.y)! {
                tableViewDefaultSize(false)
            }
            if (gestureRecognizer.view!.frame.origin.y + translation.y) < ((self.defaultAboveTableViewFrame?.origin.y)! - slideConstant) {
                tableViewBigerSize(false)
            }
            if (gestureRecognizer.view!.frame.origin.y + translation.y) < (self.defaultAboveTableViewFrame?.origin.y)! && (gestureRecognizer.view!.frame.origin.y + translation.y) >= ((self.defaultAboveTableViewFrame?.origin.y)! - slideConstant) {

            gestureRecognizer.view!.frame.origin.y += translation.y
            self.sortView.frame.origin.y       += translation.y
            self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: self.sortView.frame.maxY, width: self.tableView.frame.width, height: self.tableView.frame.height - translation.y)
            moreInfoIsOpened=true
            gestureRecognizer.setTranslation(CGPoint.zero, in: self.view)
            }
            self.currentSortViewFrame = self.sortView.frame
            self.currentTableViewFrame = self.tableView.frame
            self.currentAboveTableViewFrame = self.aboveTableView.frame
        }
    }
    func tableViewBigerSize(_ animated: Bool) {
        if !animated {
        self.aboveTableView.frame.origin.y = (self.defaultAboveTableViewFrame?.origin.y)! - slideConstant
        self.sortView.frame.origin.y       = (self.defaultSortViewFrame?.origin.y)! - slideConstant
        self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: (self.defaultTableViewFrame?.origin.y)! - slideConstant, width: self.tableView.frame.width, height: (self.defaultTableViewFrame?.height)! + slideConstant)
        self.moreInfoIsOpened = true
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.aboveTableView.frame.origin.y = (self.defaultAboveTableViewFrame?.origin.y)! - slideConstant
                self.sortView.frame.origin.y       = (self.defaultSortViewFrame?.origin.y)! - slideConstant
                self.tableView.frame = CGRect(x: self.tableView.frame.origin.x, y: (self.defaultTableViewFrame?.origin.y)! - slideConstant, width: self.tableView.frame.width, height: (self.defaultTableViewFrame?.height)! + slideConstant)
            }, completion: { (success) in
                self.moreInfoIsOpened = true
            })

        }
        
    }
    func tableViewDefaultSize(_ animated: Bool){
        if !animated {
        self.aboveTableView.frame         = self.defaultAboveTableViewFrame!
        self.tableView.frame              = self.defaultTableViewFrame!
        self.sortView.frame               = self.defaultSortViewFrame!
        self.moreInfoIsOpened = false
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.aboveTableView.frame         = self.defaultAboveTableViewFrame!
                self.tableView.frame              = self.defaultTableViewFrame!
                self.sortView.frame               = self.defaultSortViewFrame!
            }, completion: { (success) in
                self.moreInfoIsOpened = false
            })
        }
    }
    //MARK: GMSMapViewDelegate
    
    func configurateMap() {
        let camera = GMSCameraPosition.camera(withLatitude: 55.75, longitude: 37.62, zoom: 13.0)
        mapViewGoogle = GMSMapView.map(withFrame: self.mapView.frame, camera: camera)
        mapViewGoogle.isMyLocationEnabled = true
        mapViewGoogle.delegate = self
        mapView.addSubview(mapViewGoogle)
    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        return UIView()
    }

    //MARK: Display views
    override func viewWillAppear(_ animated: Bool) {
        displayView()
        setSearchView()
    }
    
    func setSearchView(){
        let searchBarHeight : CGFloat = 45
        let searchBarView = UIView(frame: CGRect(x: self.view.bounds.width * 0.05, y: gradientView.frame.maxY - searchBarHeight/2, width: self.view.frame.width * 0.9, height:searchBarHeight ))
        searchBarView.backgroundColor = UIColor.white
        searchBarView.layer.cornerRadius = 4
        searchBarView.addShadow(opacity: 1, radius: 1)
        
        //TEXTFIELD
        let textField = UITextField(frame: CGRect(x: view.bounds.width * 0.2, y: gradientView.frame.maxY - searchBarHeight/2, width: view.bounds.width * 0.6, height: searchBarView.bounds.height))
        textField.placeholder = gasSearchTextPlaceHolder
        textField.textAlignment = .left
        textField.font = UIFont.italicSystemFont(ofSize: 14)

        let buttonsHeight = searchBarView.bounds.height
        let leftButton = UIButton(frame: CGRect(x: view.bounds.width * 0.05, y: gradientView.frame.maxY - buttonsHeight/2 , width: view.bounds.width * 0.1, height:buttonsHeight))
        leftButton.imageView?.contentMode = UIViewContentMode.center
        leftButton.setImage(#imageLiteral(resourceName: "pin"), for: .normal)
        
        let rightButtonHeight = searchBarView.bounds.height * 0.9
        let rightButton = UIButton(frame: CGRect(x: view.bounds.width * 0.83, y: gradientView.frame.maxY - rightButtonHeight/2 , width: view.bounds.width * 0.1, height:rightButtonHeight))
        rightButton.imageView?.contentMode = .center
        rightButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)

        self.view.addSubview(searchBarView)
        self.view.addSubview(leftButton)
        self.view.addSubview(rightButton)
        self.view.addSubview(textField)
    }
    
    func displayView(){
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        gradientView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.128)
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
   
        aboveTableView.layer.cornerRadius         = 10
        aboveTableView.addShadow(opacity: 3, radius: 2)
        moreStationsinfoButton.layer.cornerRadius = 10
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
            case UISwipeGestureRecognizerDirection.right:
                //write your logic for right swipe
                sortByPrice.setTitleColor(UIColor.white, for: .normal)
                sortByRange.setTitleColor(UIColor.noActiveButton, for: .normal)
                UIView.animate(withDuration: 0.4) {
                    self.smallCornerView.center = CGPoint(x: self.sortByPrice.frame.midX, y: self.smallCornerView.center.y)
                }
                var stationTemp = Station()
                let count = gasStations.count - 1
                for j in 0..<count {
                    for i in 0..<count - j{
                        if gasStations[i].price > gasStations[i+1].price {
                            stationTemp = gasStations[i]
                            gasStations[i] = gasStations[i+1]
                            gasStations[i+1] = stationTemp
                        }
                    }
                }
                self.tableView.reloadData()
                
            case UISwipeGestureRecognizerDirection.left:
                //write your logic for left swipe
                sortByRange.setTitleColor(UIColor.white, for: .normal)
                sortByPrice.setTitleColor(UIColor.noActiveButton, for: .normal)
                UIView.animate(withDuration: 0.4) {
                    self.smallCornerView.center = CGPoint(x: self.sortByRange.frame.midX, y: self.smallCornerView.center.y)
                }
                var stationTemp = Station()
                let count = gasStations.count - 1
                for j in 0..<count {
                    for i in 0..<count - j{
                        if gasStations[i].distanseLength > gasStations[i+1].distanseLength {
                            stationTemp = gasStations[i]
                            gasStations[i] = gasStations[i+1]
                            gasStations[i+1] = stationTemp
                        }
                    }
                }
                
                self.tableView.reloadData()
                
            default:
                break
            }
        }
    }
    
    func setBarButtons() {
        let settingsButton = UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(settings))
        settingsButton.tintColor = UIColor.init(red: 0, green: 137/255, blue: 178/255, alpha: 1)
        let profileButton = UIBarButtonItem(image: #imageLiteral(resourceName: "profile"), style: .plain, target: self, action: #selector(profile))
        self.navigationItem.rightBarButtonItem = settingsButton
        self.navigationItem.leftBarButtonItem  = profileButton
        
    }
    
    //MARK: Actions
    func closeKeyboard(){
        view.endEditing(true)
    }

    func settings(){
        
    }
    func profile() {
    }
    
    //MARK:Sort methods
    
    @IBAction func byRange(_ sender: UIButton) {
        sortByRange.setTitleColor(UIColor.white, for: .normal)
        sortByPrice.setTitleColor(UIColor.noActiveButton, for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.smallCornerView.center = CGPoint(x: self.sortByRange.frame.midX, y: self.smallCornerView.center.y)
        }
        var stationTemp = Station()
        let count = gasStations.count - 1
        for j in 0..<count {
            for i in 0..<count - j{
                if gasStations[i].distanseLength > gasStations[i+1].distanseLength {
                    stationTemp = gasStations[i]
                    gasStations[i] = gasStations[i+1]
                    gasStations[i+1] = stationTemp
                }
            }
        }
        
        self.tableView.reloadData()

           }
    
    @IBAction func byPrice(_ sender: UIButton) {
        sortByPrice.setTitleColor(UIColor.white, for: .normal)
        sortByRange.setTitleColor(UIColor.noActiveButton, for: .normal)
        UIView.animate(withDuration: 0.4) {
            self.smallCornerView.center = CGPoint(x: self.sortByPrice.frame.midX, y: self.smallCornerView.center.y)
        }
        var stationTemp = Station()
        let count = gasStations.count - 1
        for j in 0..<count {
            for i in 0..<count - j{
                if gasStations[i].price > gasStations[i+1].price {
                    stationTemp = gasStations[i]
                    gasStations[i] = gasStations[i+1]
                    gasStations[i+1] = stationTemp
                }
            }
        }
        self.tableView.reloadData()

    }
    override func viewDidLayoutSubviews() {
        if moreInfoIsOpened {
            tableViewBigerSize(false)
        }
    }
}


extension ViewController: UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GasStationCell
        let currentStation = gasStations[indexPath.row]
        cell.priceLabel.text    = String(currentStation.price)
        cell.streetName.text    = currentStation.streetName
        cell.distanseLabel.text = String(currentStation.distanseLength) + " км"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let currentStation = gasStations[indexPath.row]
        mapViewGoogle.clear()
        let marker = GMSMarker()
        let pinView = PinView().loadFromNib() as! PinView
        pinView.gasStationImageView.image = #imageLiteral(resourceName: "shellStation")
        pinView.priceLabel.text           = String(currentStation.price)
        pinView.streetNameLabel.text      = currentStation.streetName
        marker.iconView = pinView
        marker.position = CLLocationCoordinate2D(latitude: currentStation.latitude, longitude: currentStation.longitude)
        marker.appearAnimation = .pop
        marker.map = mapViewGoogle
        mapViewGoogle.selectedMarker = marker
        mapViewGoogle.camera = GMSCameraPosition.camera(withLatitude: currentStation.latitude, longitude: currentStation.longitude, zoom: 14)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gasStations.count
    }
}

