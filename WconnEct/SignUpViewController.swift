//
//  SignUpViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 27/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController,GIDSignInDelegate,GIDSignInUIDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailIDField: UITextField!
    var activeTextField: UITextField!
    
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactNumberField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var genderSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var teacherOrStudentSegmentControl: UISegmentedControl!

    var data : NSMutableData = NSMutableData()
    var isTeacherDuringGoogleOrFacebookSignUp : Bool = true
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.login")
        GIDSignIn.sharedInstance().scopes.append("https://www.googleapis.com/auth/plus.me")
        
        registerForKeyboardNotifications()
        nameTextField.delegate = self
        contactNumberField.delegate = self
        passwordField.delegate = self
        emailIDField.delegate = self
        
        self.view.userInteractionEnabled = true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action:"hidesKeyboard")
        self.view.addGestureRecognizer(tap)
        
        
        // Do any additional setup after loading the view.
    }
    
    func hidesKeyboard()
    {
        if self.activeTextField != nil
        {
            view.endEditing(true)
        }
        
    }
    func showUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id, name, gender, first_name, last_name, locale, email"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                print("Error: \(error)")
            }
            else
            {
                let userName : NSString = result.valueForKey("name") as! NSString
                print("User Name is: \(userName)")
                
                if let userEmail : NSString = result.valueForKey("email") as? NSString {
                    print("User Email is: \(userEmail)")
                }
            }
        })
    }
    override func viewWillAppear(animated: Bool)
    {
//        if (FBSDKAccessToken.currentAccessToken() != nil)
//        {
//            self.getFBUserData()
//            
//        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Call this method somewhere in your view controller setup code.
    func registerForKeyboardNotifications() {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector:  #selector(SignUpViewController.keyboardWasShown(_:)), name: UIKeyboardDidShowNotification, object: nil)
        center.addObserver(self, selector: #selector(SignUpViewController.keyboardWillBeHidden(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unregisterFromKeyboardNotifications () {
        let center:  NSNotificationCenter = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardDidShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    func keyboardWasShown (notification: NSNotification) {
        let info : NSDictionary = notification.userInfo!
        let kbSize = (info.objectForKey(UIKeyboardFrameBeginUserInfoKey)?.CGRectValue() as CGRect!).size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        var aRect = self.view.frame
        aRect.size.height -= kbSize.height;
        if self.activeTextField != nil
        {
            if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
                self.scrollView.scrollRectToVisible(self.activeTextField.frame, animated: true)
            }
        }
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    func keyboardWillBeHidden (notification: NSNotification) {
        let contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.activeTextField = nil
    }
    @IBAction func googleSignUp(sender: AnyObject)
    {
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let actionForTeacher = UIAlertAction(title: "Teacher", style: .Default, handler: {(alert: UIAlertAction!) in
            GIDSignIn.sharedInstance().signIn()
            })
        let actionForStudent = UIAlertAction(title: "Student/Parent", style: .Default, handler: {(alert: UIAlertAction!) in
            self.isTeacherDuringGoogleOrFacebookSignUp = false
            GIDSignIn.sharedInstance().signIn()
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)

        actionSheet.addAction(actionForStudent)
        actionSheet.addAction(actionForTeacher)
        actionSheet.addAction(dismissAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }
    
    func signIn(signIn: GIDSignIn!, didDisconnectWithUser user: GIDGoogleUser!, withError error: NSError!) {
        
    }
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!, withError error: NSError!) {
        if let _ = error {
            print(error)
        }
        else {
            print(GIDSignIn.sharedInstance().currentUser.profile.name)
            print(GIDSignIn.sharedInstance().currentUser.profile.email)
            let requestObject = RequestBuilder()
            requestObject.requestForSignUp(String(GIDSignIn.sharedInstance().currentUser.profile.name), phNumber: "000000", emailID: String(GIDSignIn.sharedInstance().currentUser.profile.email), password: "", gender: "", photo: "", isTeacher:self.isTeacherDuringGoogleOrFacebookSignUp )
            requestObject.completionHandler =
                {
                    dataValue in
                    dispatch_async(dispatch_get_main_queue(),
                                   {
                                    let parser = SignUpParser()
                                    if parser.isparsedSignUpDetailsUsingData(dataValue)
                                    {
                                        self.dismissViewControllerAnimated(true, completion: {
                                            let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
                                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                            alert.addAction(alertAction)
                                            self.presentViewController(alert, animated: true, completion: nil)
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
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: {
                self.showActivityIndicator()


            
        })
    }
    
    @IBAction func facebooksignUp(sender: AnyObject)
    {
        
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let actionForTeacher = UIAlertAction(title: "Teacher", style: .Default, handler: {(alert: UIAlertAction!) in
            
            self.callFacebooksignUpFunction()
        })
        let actionForStudent = UIAlertAction(title: "Student/Parent", style: .Default, handler: {(alert: UIAlertAction!) in
            self.isTeacherDuringGoogleOrFacebookSignUp = false
            self.callFacebooksignUpFunction()
        })
        let dismissAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        
        actionSheet.addAction(actionForStudent)
        actionSheet.addAction(actionForTeacher)
        actionSheet.addAction(dismissAction)
        self.presentViewController(actionSheet, animated: true, completion: nil)
        

    }
    
    func callFacebooksignUpFunction() ->Void
    {
        let login : FBSDKLoginManager = FBSDKLoginManager()
        let  readPermissions = ["public_profile", "email", "user_friends"]
        login.logInWithReadPermissions(readPermissions, fromViewController: self, handler: {(result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
            if error != nil {
                print(FBSDKAccessToken.currentAccessToken())
            } else if result.isCancelled {
                print("Cancelled")
            } else {
//                print("LoggedIn")
//                let alert = UIAlertController(title: nil, message: "Logging In...", preferredStyle: .Alert)
//                alert.view.tintColor = UIColor.blackColor()
//                let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
//                loadingIndicator.hidesWhenStopped = true
//                loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//                loadingIndicator.startAnimating()
//                
//                alert.view.addSubview(loadingIndicator)
//                self.presentViewController(alert, animated: true, completion: nil)
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
                    print(result)
                    let requestObject = RequestBuilder()
                    requestObject.requestForSignUp(String(result.objectForKey("name")!), phNumber: "0000000000", emailID: String(result.objectForKey("email")!), password: "", gender: "", photo: "", isTeacher:self.isTeacherDuringGoogleOrFacebookSignUp )
                        requestObject.completionHandler =
                        {
                            dataValue in
                            dispatch_async(dispatch_get_main_queue(),
                                {
                                let parser = SignUpParser()
                                if parser.isparsedSignUpDetailsUsingData(dataValue)
                                {
                                    self.dismissViewControllerAnimated(true, completion: {
                                    let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
                                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                                    alert.addAction(alertAction)
                                    self.presentViewController(alert, animated: true, completion: nil)
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
    
    
    

    @IBAction func signUp(sender: AnyObject)
    {
        
        var gender : String = ""
        var isTeacher : Bool = true
        if genderSegmentControl.selectedSegmentIndex == 0
        {
            gender = "Female"
        }
        else
        {
            gender = "Male"
        }
        if teacherOrStudentSegmentControl.selectedSegmentIndex == 0
        {
            isTeacher = true
        }
        else
        {
            isTeacher = false
        }
        if nameTextField.text == "" || passwordField.text == "" || emailIDField.text == "" || contactNumberField.text == ""
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
            requestObject.requestForSignUp(String(UTF8String: nameTextField.text!)!, phNumber: String(UTF8String:contactNumberField.text!)!, emailID: String(UTF8String: emailIDField.text!)!, password: String(UTF8String: passwordField.text!)!, gender: gender, photo:String(UTF8String: "[]")!, isTeacher: isTeacher)
            requestObject.completionHandler = { dataValue in
                dispatch_async(dispatch_get_main_queue(), {
                    let parser = SignUpParser()
                    if parser.isparsedSignUpDetailsUsingData(dataValue)
                    {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                    else
                    {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        let alert = UIAlertController(title: "Error", message: parser.messageFromParser, preferredStyle:.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }
                    
    
                })
                
            }
            
            
        }
        

        
        
        

    }

    func showActivityIndicator()
    {
        let alert = UIAlertController(title: nil, message: "Creating an Account...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)

    }
//    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        print(NSString(data: data, encoding: NSUTF8StringEncoding))
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
//    }

}
