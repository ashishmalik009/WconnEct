//
//  LogInViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 21/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var facebookSignInView: UIView!
    @IBOutlet weak var googleSignInView: UIView!
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
        
        self.emailIdTextField.delegate = self
        self.passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(animated: Bool)
    {
       if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
       {
            let isInternetConnected = delegate.checkNetworkStatus()
        if !isInternetConnected
        {
            let alert = UIAlertController(title: "No Internet", message: "Your device is not connected to Internet", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
             presentViewController(alert, animated: true, completion: nil)
            
        }
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        GIDSignIn.sharedInstance().delegate = self
    }
    
       @IBAction func signIn(sender: AnyObject)
       {
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let actionForTeacher = UIAlertAction(title: "Teacher", style: .Default, handler: {(alert: UIAlertAction!) in
            
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = true
            }
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
//        actionSheet.popoverPresentationController?.sourceView = self.googleSignInView
        actionSheet.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: googleSignInView)
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
        }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!) {
        
        if let _ = error {
            CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
            print(error)
            let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
            print(GIDSignIn.sharedInstance().currentUser.profile.name)
            print(GIDSignIn.sharedInstance().currentUser.profile.email)
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                self.requestToLogIn(String(GIDSignIn.sharedInstance().currentUser.profile.email), password:"", isTeacher:delegate.isTeacherLoggedIn)
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
        CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
        
            
        
       
        
        
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
            
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = true
            }

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
        actionSheet.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: self.facebookSignInView)
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
                CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
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
                    if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                    {
                            self.requestToLogIn(String(result.objectForKey("email")!), password:"", isTeacher: delegate.isTeacherLoggedIn)
                    }
                    
                }

            })
        }
        
    }
    
//    func showActivityIndicator()
//    {
//        let alert = UIAlertController(title: nil, message: "Authenticating...", preferredStyle: .Alert)
//        
//        alert.view.tintColor = UIColor.blackColor()
//        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        loadingIndicator.startAnimating()
//        
//        alert.view.addSubview(loadingIndicator)
//        presentViewController(alert, animated: true, completion: nil)
//        
//    }
    @IBAction func logIn(sender: AnyObject)
    {
        var isTeacher : Bool = false
        if segmentControl.selectedSegmentIndex == 0
        {
            
            isTeacher = true
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = true
            }

        }
        else
        {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isTeacherLoggedIn = false
            }
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
            CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
            self.requestToLogIn(String(UTF8String: emailIdTextField.text!)!, password: String(UTF8String: passwordTextField.text!)!, isTeacher: isTeacher)
        }

    }
    
    func requestToLogIn(emailId:String , password: String,isTeacher:Bool)
    {
        let requestObject = RequestBuilder()
        requestObject.requestForLogIn(emailId, password:password, isTeacher: isTeacher)
        requestObject.errorHandler = { error in
            
            dispatch_async(dispatch_get_main_queue(),{
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                    
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
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                        
                        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                        {
                            delegate.emailIdOfLoggedInUser = emailId
                            delegate.isUserLoggedIn = true
                        }
                    let tabbarcontroller = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarControllerStorboardIDForStudent") as! UITabBarController
                        self.presentViewController(tabbarcontroller, animated: true, completion: nil)
                        
                    
                }
                    
                else
                {
                        CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                        let alert = UIAlertController(title: "Error", message: parser.messageFromParser, preferredStyle:.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    
                    
                }
                
                
            })
            
            
        }
        
    }
    
    // MARK : TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    

}






