//
//  UserProfileViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 08/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate
{
    
    var userName: String = ""
    var phNumber : String = ""
    var gender : String = ""
    var emailId : String = ""
    var base64encodedString : String = ""
    var updatedDataTupleArray : [(_:String, _:String)] = []
    var isImagePickerSelected : Bool = false
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
     @IBOutlet weak var backgroundImageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserProfileViewController.screenTapped(_:)))
        self.profileImageView.addGestureRecognizer(tapRecognizer)
//        self.profileTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        

        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            self.backgroundImageView.backgroundColor = UIColor.clearColor()
            
            let blurEffect = UIBlurEffect(style: .Light)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.backgroundImageView.bounds
            blurEffectView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
            
            self.backgroundImageView.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        } else {
            self.backgroundImageView.backgroundColor = UIColor.clearColor()
        }

    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        
    }
    func callFetchData()
    {
        CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
        let requestObject = RequestBuilder()
        requestObject.requestForProfileOfUser()
       
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
               CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                let parser = ProfileUserParser()
                if parser.isparsedPRrofileUserUsingData(dataValue)
                {
                    self.userName = parser.name
                    self.phNumber = parser.contactNumber
                    self.gender = parser.gender
                    self.emailId = parser.email
                    self.base64encodedString = parser.base64encodedStringFromServer
                    let imageData = NSData(base64EncodedString: self.base64encodedString, options:NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
                    let image = UIImage(data: imageData!)
                    if image == nil
                    {
                        self.profileImageView.image = UIImage.init(named: "defaultUserIcon")
                        self.backgroundImageView.backgroundColor = UIColor.grayColor()
                        self.backgroundImageView.image = UIImage.init(named: "defaultUserIcon")
                    }
                    else
                    {
                        self.profileImageView.image = image
                        self.saveImageDocumentDirectory(image!)
                        self.backgroundImageView.backgroundColor = UIColor.grayColor()
                        self.backgroundImageView.image = image

                    }
                    self.profileTableView.reloadData()
                    
                }
            
        
        
            })
            
        
        }
    }
    func saveImageDocumentDirectory(finalImage : UIImage)
    {
        let fileManager = NSFileManager.defaultManager()
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let path = (NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString).stringByAppendingPathComponent("\(delegate.emailIdOfLoggedInUser).jpg")
            let image = finalImage
            print(path)
            let imageData = UIImageJPEGRepresentation(image, 0.5)
            fileManager.createFileAtPath(path as String, contents: imageData, attributes: nil)
        }
        
        
    }
    
    func screenTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        isImagePickerSelected = true
        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
        let galleryAction = UIAlertAction(title: "Open Gallery", style: .Default, handler: {(alert: UIAlertAction!) in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
            imagePickerController.allowsEditing = true
            self.presentViewController(imagePickerController, animated: true, completion: { imageP in
                
            })
        })
        let chooseCameraAction = UIAlertAction(title:"Open Camera", style: .Default, handler:{ (alert: UIAlertAction!) in
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            if UIImagePickerController.isSourceTypeAvailable(.Camera)
            {
                imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
                imagePickerController.allowsEditing = true
                self.presentViewController(imagePickerController, animated: true, completion: { imageP in
                
            })
            }
            else
            {
                let alert = UIAlertController(title: "Error", message: "Camera not available", preferredStyle: .Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            })
        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
        actionSheet.addAction(galleryAction)
        actionSheet.addAction(chooseCameraAction)
        actionSheet.addAction(cancelAction)
        presentViewController(actionSheet, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
       if !isImagePickerSelected
       {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                if delegate.isUserLoggedIn
                {
                    self.callFetchData()
                }
                else
                {
                    let alert = UIAlertController(title: "WconnEct", message: "Please login to continue", preferredStyle: .Alert)
                    let alertAction = UIAlertAction(title: "LogIn", style: .Default, handler: { alertAction in
                        
                        let loginController = self.storyboard?.instantiateViewControllerWithIdentifier("loginStoryboardID") as! LogInViewController
                        let nav = UINavigationController(rootViewController: loginController)
                        
                        self.presentViewController(nav, animated: true, completion: nil)
                        
                    })
                    let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
                    
                    alert.addAction(alertAction)
                    alert.addAction(cancelAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                    
                }
            }

        }
    }
    

    @IBAction func save(sender: AnyObject)
    {
        var updatedUsername : String = ""
        var updatedPhoneNumber :String = ""
        for i in 0..<3
        {
            let updatedTableViewCell = self.profileTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ProfileUserTableViewCell
            switch i
            {
                case 0: updatedUsername = String(updatedTableViewCell.detailTextField.text!)
                case 2: updatedPhoneNumber = String(updatedTableViewCell.detailTextField.text!)
                
            default: print("Nothing")
                
            }
            
            
        }
        let updatedGenderCell = self.profileTableView.cellForRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0)) as! GenderProfileTableViewCell
        let genderValue = updatedGenderCell.genderSegmentControl.selectedSegmentIndex
        var updatedGender : String = ""
        if genderValue == 0
        {
            updatedGender = "Male"
        }
        else
        {
            updatedGender = "Female"
        }
        let image : UIImage = self.profileImageView.image!
        self.saveImageDocumentDirectory(image)
        let imageData : NSData = UIImagePNGRepresentation(image)!
        let imageStringAfterDecoding = imageData.base64EncodedStringWithOptions(.EncodingEndLineWithLineFeed)
        if updatedUsername != userName
        {
            let updatedTuple = ("name",updatedUsername)
            updatedDataTupleArray.append(updatedTuple)
        }
        if updatedPhoneNumber != phNumber
        {
            let updatedTuple = ("ph_number",updatedPhoneNumber)
            updatedDataTupleArray.append(updatedTuple)
        }
        if updatedGender != gender
        {
            let updatedTuple = ("gender",updatedGender)
            updatedDataTupleArray.append(updatedTuple)

        }
        
        if imageStringAfterDecoding != base64encodedString
        {
            let updatedTuplePhoto = ("photo",emailId)
            updatedDataTupleArray.append(updatedTuplePhoto)
            let updatedTuple = ("photoData",imageStringAfterDecoding)
            updatedDataTupleArray.append(updatedTuple)
        }


        let requestObject = RequestBuilder()
        requestObject.requestToUpdateData(updatedDataTupleArray)
            CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
            requestObject.errorHandler = { error in
                
                CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                    dispatch_async(dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                })
            }
            
            requestObject.completionHandler = { dataValue in
                dispatch_async(dispatch_get_main_queue(), {
                    let parser = ProfileUserParser()
                    if parser.isparsedPRrofileUserAfterUpdateingData(dataValue)
                    {
                            CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                            let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(alertAction)
                            self.presentViewController(alert, animated: true, completion: nil)
  
                        
                    }
                })
                
            }
            
        
    }
    func showActivityIndicator(message:String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Mark : tableViewDelegates and resources
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablewViewCell = tableView.dequeueReusableCellWithIdentifier("profileCellIdentifier") as! ProfileUserTableViewCell
        let tableViewCellForGender = tableView.dequeueReusableCellWithIdentifier("genderProfileIdentifer") as! GenderProfileTableViewCell
        let tableViewCellLogout = tableView.dequeueReusableCellWithIdentifier("otherIdentifier") 
        tablewViewCell.detailTextField.delegate = self
        if indexPath.row == 0
        {
            tablewViewCell.detailTextField.text = String("\(userName)")
            tablewViewCell.detailTextField.placeholder = "name"
            
        }
        else if indexPath.row == 1
        {
            tablewViewCell.iconLabel.text = ""
            tablewViewCell.detailTextField.text = String("\(emailId)")
            tablewViewCell.detailTextField.enabled = false
            tablewViewCell.detailTextField.placeholder = "EmailId"
        }
        else if indexPath.row == 2
        {
            tablewViewCell.detailTextField.text = String("\(phNumber)")
            tablewViewCell.detailTextField.placeholder = "Contact Numebr"
            tablewViewCell.detailTextField.keyboardType = .NumberPad 
        }
        else if indexPath.row == 3
        {
            if gender == "Male"
            {
                tableViewCellForGender.genderSegmentControl.selectedSegmentIndex = 0
            }
            else if gender == "Female"
            {
        
                tableViewCellForGender.genderSegmentControl.selectedSegmentIndex = 1
                
            }
            
            return tableViewCellForGender
            
        }
        else if indexPath.row == 4
        {
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                if delegate.isUserLoggedIn
                {
                    tableViewCellLogout?.textLabel?.font = UIFont(name: "FontAwesome", size: 15.0)
                    tableViewCellLogout?.textLabel?.text = " Log out"
                }
                else
                {
                    tableViewCellLogout?.textLabel?.text = "Log in"
                }
            }
            
//            tableViewCellLogout?.imageView?.image = UIImage(named: "logOut")
            return tableViewCellLogout!

        }

        return tablewViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 4
        {
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
            FBSDKProfile.setCurrentProfile(nil)
            FBSDKAccessToken.setCurrentAccessToken(nil)
            self.deleteImage()
            dismissViewControllerAnimated(true, completion: { ()-> Void in
                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                {
                    delegate.isUserLoggedIn = false
                    delegate.accessTokenAfterLogin = ""
                    delegate.emailIdOfLoggedInUser = ""
                }
            })
            
        }

    }
    func deleteImage()
    {
        let fileManager = NSFileManager.defaultManager()
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let imagePath = (self.getDirectoryPath() as NSString).stringByAppendingPathComponent("\(delegate.emailIdOfLoggedInUser).jpg")
            if fileManager.fileExistsAtPath(imagePath)
            {
                
                do
                {
                    try fileManager.removeItemAtPath(imagePath)
                }
                catch let error as NSError
                {
                    print("No such File found")
                }
                
            }
        }
    }
    
    func getDirectoryPath() -> String {
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    let documentsDirectory = paths[0]
    return documentsDirectory
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return false
    }
    
    //MARK : UIImagePickerControllerDelegates
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        self.profileImageView.image = selectedImage
        self.backgroundImageView.backgroundColor = UIColor.grayColor()
        self.backgroundImageView.image = selectedImage
        self.dismissViewControllerAnimated(true, completion: nil)
    }
  }
