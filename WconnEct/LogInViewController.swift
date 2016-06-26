//
//  LogInViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 21/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().clientID = "792162020267-8vchclkrkbmfclhm1j4atlepvqm1jucl.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        GIDSignIn.sharedInstance().signInSilently()
        
        

    }
    override func viewDidAppear(animated: Bool) {
        GIDSignIn.sharedInstance().delegate = self
    }

    @IBAction func signIn(sender: AnyObject) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
        withError error: NSError!) {
           
            if let _ = error {
                print(error)
            }
            else {
                print(GIDSignIn.sharedInstance().currentUser.profile.name)
                print(GIDSignIn.sharedInstance().currentUser.profile.email)

            }
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    func signIn(signIn: GIDSignIn!,
        presentViewController viewController: UIViewController!) {
            self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
        dismissViewController viewController: UIViewController!) {
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signOut(sender: AnyObject) {
        GIDSignIn.sharedInstance().signOut()
        dismissViewControllerAnimated(true, completion: nil)
    }


}

//    var data : NSMutableData = NSMutableData()
//    let url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/teacher/")
//
//    @IBAction func logIn(sender: AnyObject)
//    {
//        let request: NSURLRequest = NSURLRequest(URL: url!)
////        request.HTTPMethod = "POST"
//
////        let connection = NSURLConnection(request: request, delegate:self, startImmediately: true)
//        let session = NSURLSession.sharedSession()
//        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
//            (let data, let response, let error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
//            self.parseData(data!)
//            })
//
//        dataTask.resume()
////        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
////            print(NSString(data: data!, encoding: NSUTF8StringEncoding))

//    func parseData(data : NSData) -> Void {
//        do
//        {
//            var json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [[String:AnyObject]]
//            for name in json
//            {
//                print(name["ph_number"])
//                if let phNumber = name["ph_number"]
//                {
//                    print(phNumber)
//                }
//            }
//            print(json)
//
//        }catch{
//            print("error serializing JSON: \(error)")
//        }
//
//    }
//    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        print(NSString(data: data, encoding: NSUTF8StringEncoding))
//        do
//        {
//            var json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [[String:AnyObject]]
//            for name in json
//            {
//                print(name["ph_number"])
//            if let phNumber = name["ph_number"]
//            {
//                print(phNumber)
//                }
//            }
//            print(json)
//
//        }catch{
//            print("error serializing JSON: \(error)")
//        }
//    }



    

