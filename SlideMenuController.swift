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
        
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            if delegate.isUserLoggedIn
            {
                let profileUserController = self.storyboard?.instantiateViewControllerWithIdentifier("userProfileStoryBoardID") as! UserProfileViewController
                let navController = UINavigationController(rootViewController: profileUserController)
                self.presentViewController(navController, animated: true, completion: nil)
            }
        }
        
        
    }
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            self.userNameLabel.text = delegate.emailIdOfLoggedInUser
        }
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
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
               if delegate.isUserLoggedIn
               {
                tableViewCell?.textLabel?.text = "Log out"
               }
                else
               {
                tableViewCell?.textLabel?.text = "Log in"
               }
            }
            
            tableViewCell?.imageView?.image = UIImage(named: "logOut")
        }
        return tableViewCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3
        {
            GIDSignIn.sharedInstance().signOut()
            FBSDKLoginManager().logOut()
            FBSDKProfile.setCurrentProfile(nil)
            FBSDKAccessToken.setCurrentAccessToken(nil)
            dismissViewControllerAnimated(true, completion: nil)
            if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
            {
                delegate.isUserLoggedIn = false
                delegate.accessTokenAfterLogin = ""
                delegate.emailIdOfLoggedInUser = ""
            }


        }
    }
}
