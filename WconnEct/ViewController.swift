//
//  ViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 20/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    @IBOutlet weak var locationBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
//        GIDSignIn.sharedInstance().uiDelegate = self        // Do any additional setup after loading the view, typically from a nib.
//        GIDSignIn.sharedInstance().uiDelegate = self
        
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        startLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            self.getFBUserData()
            
        }
    }
    func getFBUserData()
    {
//        if((FBSDKAccessToken.currentAccessToken()) != nil)
//        {
//            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
//                if (error == nil){
//                    print(result)
//                    
//                }
//            })
//        }
        
    }
    
    @IBAction func skipLogin(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    
        let tabbarcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarControllerStorboardIDForStudent") as! UITabBarController
        self.presentViewController(tabbarcontroller, animated: true, completion: nil)


    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
        {
            let latestLocation: CLLocation = locations[locations.count - 1]
            
            var latitude : CLLocationDegrees = 0.0
            var long : CLLocationDegrees = 0.0
            latitude = latestLocation.coordinate.latitude
            
            print("latitude is\(latitude)")
            long = latestLocation.coordinate.longitude
            
            print("longitude is\(long)")


            if self.startLocation == nil {
                startLocation = latestLocation 
            }

                let geoCoder = CLGeocoder()
                let location = CLLocation(latitude: latitude, longitude:long)
                geoCoder.reverseGeocodeLocation(location)
                {
                    (placemarks, error) -> Void in
                    
                    let placeArray = placemarks as [CLPlacemark]!
                    if placeArray != nil
                    {
                        if let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate
                        {
                            appdelegate.myLatitude = latitude
                            appdelegate.myLongitude = long
                        }
                        // Place details
                        var placeMark: CLPlacemark!
                        placeMark = placeArray?[0]
                        
                        // Address dictionary
                        print(placeMark.addressDictionary)
                        
                        // Location name
                        if let locationName = placeMark.addressDictionary?["Name"] as? NSString
                        {
                            print(locationName)
                        }
                        
                        // Street address
                        if let street = placeMark.addressDictionary?["Thoroughfare"] as? NSString
                        {
                            print(street)
                        }
                        
                        // City
                        if let city = placeMark.addressDictionary?["City"] as? NSString
                        {
                            print(city)
                            
                        }
                        if let sublocality = placeMark.addressDictionary?["SubLocality"] as? NSString
                        {
                            print(sublocality)
                            self.locationBarButton.title = "\(sublocality)"
                        }
                        
                        // Zip code
                        if let zip = placeMark.addressDictionary?["ZIP"] as? NSString
                        {
                            print(zip)
                        }
                        
                        // Country
                        if let country = placeMark.addressDictionary?["Country"] as? NSString
                        {
                            print(country)
                        }
                    }
                }
            
            
            
            
          
        }
    
    func locationManager(manager: CLLocationManager,
                         didFailWithError error: NSError) {
        
        print("Error while getting core location :\(error.localizedDescription)")
        
    }
    
}

