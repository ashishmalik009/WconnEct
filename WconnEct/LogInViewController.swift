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
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        //        GIDSignIn.sharedInstance().clientID = "792162020267-8vchclkrkbmfclhm1j4atlepvqm1jucl.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
//        GIDSignIn.sharedInstance().signInSilently()
        
    }
    
    override func viewWillAppear(animated: Bool) {
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            self.getFBUserData()
//            
//        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        GIDSignIn.sharedInstance().delegate = self
    }
    
       @IBAction func signIn(sender: AnyObject) {
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let actionForTeacher = UIAlertAction(title: "Teacher", style: .Default, handler: {(alert: UIAlertAction!) in
            GIDSignIn.sharedInstance().signIn()
        })
        let actionForStudent = UIAlertAction(title: "Student/Parent", style: .Default, handler: {(alert: UIAlertAction!) in
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = false
            }
            GIDSignIn.sharedInstance().signIn()
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        actionSheet.addAction(actionForStudent)
        actionSheet.addAction(actionForTeacher)
        actionSheet.addAction(dismissAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        
        if let _ = error {
            print(error)
            let alert = UIAlertController(title: "Error", message: "The login flow has been cancelled", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            self.showActivityIndicator()
            print(GIDSignIn.sharedInstance().currentUser.profile.name)
            print(GIDSignIn.sharedInstance().currentUser.profile.email)
            let requestObject = RequestBuilder()
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                requestObject.requestForLogIn(String(GIDSignIn.sharedInstance().currentUser.profile.email), password:"", isTeacher:delegate.isTeacherLoggedIn)
            }
            requestObject.errorHandler = { error in
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion:{
                    let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
            
            requestObject.completionHandler = { dataValue in
                dispatch_async(dispatch_get_main_queue(), {
                    let parser = LogInParser()
                    if parser.isparsedLogInDetailsUsingData(dataValue)
                    {
                        self.dismissViewControllerAnimated(true, completion:{
                            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                            {
                                delegate.emailIdOfLoggedInUser = String(GIDSignIn.sharedInstance().currentUser.profile.email)
                                delegate.isUserLoggedIn = true
                            }
                            let revealController = self.storyboard?.instantiateViewControllerWithIdentifier("revealControllerIdentifier") as! SWRevealViewController
                            self.presentViewController(revealController, animated: true, completion: nil)
                        })
                        
                    }
                    else
                    {
                        self.dismissViewControllerAnimated(true, completion: {
                            let alert = UIAlertController(title: "Error", message: parser.messageFromParser, preferredStyle:.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(alertAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                        
                        
                    }
                    
                    
                })
                
                
            }
            
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
        
        self.dismissViewControllerAnimated(true, completion:nil)
            
        
       
        
        
    }
    
    
    @IBAction func signOut(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signOut()
        FBSDKLoginManager().logOut()
        FBSDKProfile.setCurrentProfile(nil)
        FBSDKAccessToken.setCurrentAccessToken(nil)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func facebookSignIn(sender: AnyObject)
    {
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let actionForTeacher = UIAlertAction(title: "Teacher", style: .Default, handler: {(alert: UIAlertAction!) in
            
            self.callFacebookSignInFunction()
        })
        let actionForStudent = UIAlertAction(title: "Student/Parent", style: .Default, handler: {(alert: UIAlertAction!) in
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = false
            }
            self.callFacebookSignInFunction()
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        actionSheet.addAction(actionForStudent)
        actionSheet.addAction(actionForTeacher)
        actionSheet.addAction(dismissAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)

        
        
        
        
    }
    func callFacebookSignInFunction()
    {
        let login : FBSDKLoginManager = FBSDKLoginManager()
        let  readPermissions = ["public_profile", "email", "user_friends"]
        login.logInWithReadPermissions(readPermissions, fromViewController: self, handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                print(FBSDKAccessToken.currentAccessToken())
            } else if result.isCancelled {
                print("Cancelled")
            } else {
                print("LoggedIn")
                self.showActivityIndicator()
                self.getFBUserData()
                
            }
            
        })

    }
    func getFBUserData()
    {
        if((FBSDKAccessToken.currentAccessToken()) != nil)
        {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil)
                {
                    let requestObject = RequestBuilder()
                    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    {
                        requestObject.requestForLogIn(String(result.objectForKey("email")!), password:"", isTeacher: delegate.isTeacherLoggedIn)
                    }
                    requestObject.errorHandler = { error in
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.dismissViewControllerAnimated(true, completion: nil)
                            let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(alertAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                    }
                    
                    requestObject.completionHandler = { dataValue in
                        dispatch_async(dispatch_get_main_queue(), {
                            let parser = LogInParser()
                            if parser.isparsedLogInDetailsUsingData(dataValue)
                            {
                                self.dismissViewControllerAnimated(true, completion: {
                                    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                                    {
                                        delegate.emailIdOfLoggedInUser = String(result.objectForKey("email")!)
                                        delegate.isUserLoggedIn = true
                                    }
                                    let revealController = self.storyboard?.instantiateViewControllerWithIdentifier("revealControllerIdentifier") as! SWRevealViewController
                                    self.presentViewController(revealController, animated: true, completion: nil)
                                    
                                    
                                })
                             
                                
                            }
                            else
                            {
                                self.dismissViewControllerAnimated(true, completion: {
                                    let alert = UIAlertController(title: "Error", message: parser.messageFromParser, preferredStyle:.Alert)
                                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                    alert.addAction(alertAction)
                                    self.presentViewController(alert, animated: true, completion: nil)
                                })
                                
                                
                            }
                            
                            
                        })
                        
                        
                    }

                }
            })
        }
        
    }
    
    func showActivityIndicator()
    {
        let alert = UIAlertController(title: nil, message: "Authenticating...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    @IBAction func logIn(sender: AnyObject)
    {
        var isTeacher : Bool = true
        if segmentControl.selectedSegmentIndex == 0
        {
            isTeacher = true
        }
        else
        {
            isTeacher = false
        }

        if emailIdTextField.text == "" || passwordTextField.text == ""
        {
            let alert = UIAlertController(title: "Error", message: "Values cannot be empty", preferredStyle:.Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.showActivityIndicator()
            let requestObject = RequestBuilder()
            requestObject.requestForLogIn(String(UTF8String: emailIdTextField.text!)!, password: String(UTF8String:passwordTextField.text!)!, isTeacher: isTeacher)
            requestObject.errorHandler = { error in
                
                dispatch_async(dispatch_get_main_queue(),{
                    self.dismissViewControllerAnimated(true, completion: nil)
                    let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                })
            }

            requestObject.completionHandler = { dataValue in
                dispatch_async(dispatch_get_main_queue(), {
                    let parser = LogInParser()
                    if parser.isparsedLogInDetailsUsingData(dataValue)
                    {
                        self.dismissViewControllerAnimated(true, completion: {
                            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                            {
                                delegate.emailIdOfLoggedInUser = self.emailIdTextField.text!
                                delegate.isUserLoggedIn = true
                            }
                            let revealController = self.storyboard?.instantiateViewControllerWithIdentifier("revealControllerIdentifier") as! SWRevealViewController
                            self.presentViewController(revealController, animated: true, completion: nil)
                            
                            
                        })
//                        let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
//                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                        alert.addAction(alertAction)
//                        self.presentViewController(alert, animated: true, completion: nil)
                        
//                        let tabBarController = self.storyboard?.instantiateViewControllerWithIdentifier("tabbarControllerStoryboardID") as! UITabBarController
                       
                    }
                    else
                    {
                        self.dismissViewControllerAnimated(true, completion: {
                            let alert = UIAlertController(title: "Error", message: parser.messageFromParser, preferredStyle:.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(alertAction)
                            self.presentViewController(alert, animated: true, completion: nil)
                        })
                        
                        
                    }
                    
                    
                })
                
                
            }

            
        }

    }
    
}






