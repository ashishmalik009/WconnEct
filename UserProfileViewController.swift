//
//  UserProfileViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 08/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var userName: String = ""
    var phNumber : String = ""
    var gender : String = ""
    var emailId : String = ""
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileTableView: UITableView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
//        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SlideMenuController.screenTapped(_:)))
//        self.profileImageView.addGestureRecognizer(tapRecognizer)
        
    }
//    func screenTapped(gestureRecognizer: UITapGestureRecognizer)
//    {
//        let actionSheet = UIAlertController(title: "Choose", message: "", preferredStyle: .ActionSheet)
//        let galleryAction = UIAlertAction(title: "Open Gallery", style: .Default, handler: nil)
//        let chooseCameraAction = UIAlertAction(title:"Open Camera", style: .Default, handler: nil)
//        let cancelAction = UIAlertAction(title: "Cancel", style: .Destructive, handler: nil)
//        actionSheet.addAction(galleryAction)
//        actionSheet.addAction(chooseCameraAction)
//        actionSheet.addAction(cancelAction)
//        presentViewController(actionSheet, animated: true, completion: nil)
//    }
//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let requestObject = RequestBuilder()
        requestObject.requestForProfileOfUser()
        self.showActivityIndicator()
        requestObject.errorHandler = { error in
            
            self.dismissViewControllerAnimated(true, completion:{
            dispatch_async(dispatch_get_main_queue(),{
                let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            })
            })
        }
        
        requestObject.completionHandler = { dataValue in
            dispatch_async(dispatch_get_main_queue(), {
                let parser = ProfileUserParser()
                if parser.isparsedPRrofileUserUsingData(dataValue)
                {
                    self.dismissViewControllerAnimated(true, completion:{
                                                self.userName = parser.name
                                                self.phNumber = parser.contactNumber
                                                self.gender = parser.gender
                                                self.emailId = parser.email
                                                self.profileTableView.reloadData()
                    })
                }
            })
            
        }
        

    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func save(sender: AnyObject)
    {
        var updatedUsername : String = ""
        var updatedPhoneNumber :String = ""
        for i in 0..<3
        {
            let updatedTableViewCell = self.profileTableView.cellForRowAtIndexPath(NSIndexPath(forRow: i, inSection: 0)) as! ProfileUserTableViewCell
            switch i {
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
        let requestObject = RequestBuilder()
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            
            requestObject.requestToUpdateData(updatedUsername, phNumber: updatedPhoneNumber, emailID: emailId, gender: updatedGender, photo: "", isTeacher: delegate.isTeacherLoggedIn)
        }
            showActivityIndicator()
            requestObject.errorHandler = { error in
                
                self.dismissViewControllerAnimated(true, completion:{
                    dispatch_async(dispatch_get_main_queue(),{
                        let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                        let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                        alert.addAction(alertAction)
                        self.presentViewController(alert, animated: true, completion: nil)
                    })
                })
            }
            
            requestObject.completionHandler = { dataValue in
                dispatch_async(dispatch_get_main_queue(), {
                    let parser = ProfileUserParser()
                    if parser.isparsedPRrofileUserAfterUpdateingData(dataValue)
                    {
                        self.dismissViewControllerAnimated(true, completion:{
                            let alert = UIAlertController(title: "Success", message: parser.messageFromParser, preferredStyle:.Alert)
                            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alert.addAction(alertAction)
                            self.presentViewController(alert, animated: true, completion: nil)
  
                        })
                    }
                })
                
            }
            
        
    }
    func showActivityIndicator()
    {
        let alert = UIAlertController(title: nil, message: "Fetching Info...", preferredStyle: .Alert)
        
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
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tablewViewCell = tableView.dequeueReusableCellWithIdentifier("profileCellIdentifier") as! ProfileUserTableViewCell
        let tableViewCellForGender = tableView.dequeueReusableCellWithIdentifier("genderProfileIdentifer") as! GenderProfileTableViewCell
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
        return tablewViewCell
    }
  }
