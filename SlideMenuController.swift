//
//  SlideMenuController.swift
//  WconnEct
//
//  Created by Ashish Malik on 06/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SlideMenuController: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    var userName : String = ""
    var gender : String = ""
    var phNumber : String = ""
    var emailId : String = ""
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
        self.profileImageView.clipsToBounds = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SlideMenuController.screenTapped(_:)))
        self.profileImageView.addGestureRecognizer(tapRecognizer)
        
    }
    func screenTapped(gestureRecognizer: UITapGestureRecognizer)
    {
        print("ashish")
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            self.userNameLabel.text = delegate.emailIdOfLoggedInUser
        }
//        self.showActivityIndicator()
//        let requestObject = RequestBuilder()
//        requestObject.requestForProfileOfUser()
//        requestObject.errorHandler = { error in
//            
//            dispatch_async(dispatch_get_main_queue(),{
//                let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
//                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
//                alert.addAction(alertAction)
//                self.presentViewController(alert, animated: true, completion: nil)
//            })
//        }
//        
//        requestObject.completionHandler = { dataValue in
//            dispatch_async(dispatch_get_main_queue(), {
//                let parser = ProfileUserParser()
//                if parser.isparsedPRrofileUserUsingData(dataValue)
//                {
//                    self.userName = parser.name
//                    self.phNumber = parser.contactNumber
//                    self.gender = parser.gender
//                    self.emailId = parser.email
//                    self.dismissViewControllerAnimated(true, completion: nil)
//                    self.userNameLabel.text = parser.name
//                    self.profileTableView.reloadData()
//                }
//            })
//            
//        }
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
    
    //Mark : TableViewDatasource and Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("profileCellIdentifier")
        if indexPath.row == 0
        {
            tableViewCell?.textLabel?.text = "Search"
            
        }
        else if indexPath.row == 1
        {
            tableViewCell?.textLabel?.text = "Your Wish List"
        }
        else if indexPath.row == 2
        {
            tableViewCell?.textLabel?.text = "Booked Teachers"
        }
        else if indexPath.row == 3
        {
            tableViewCell?.textLabel?.text = "Log out"
            tableViewCell?.imageView?.image = UIImage(named: "logOut")
        }
        return tableViewCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
}
