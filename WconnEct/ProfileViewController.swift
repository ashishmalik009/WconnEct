//
//  ProfileViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 04/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController , UITableViewDelegate, UITableViewDataSource
{
    var userName : String = ""
    var gender : String = ""
    var phNumber : String = ""
    @IBOutlet weak var profileTableView: UITableView!
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
        self.showActivityIndicator()
        let requestObject = RequestBuilder()
        requestObject.requestForProfileOfUser()
        requestObject.errorHandler = { error in
            
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
                if parser.isparsedPRrofileUserUsingData(dataValue)
                {
                    self.userName = parser.name
                    self.phNumber = parser.contactNumber
                    self.gender = parser.gender
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.profileTableView.reloadData()
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
    
    //Mark : TableViewDatasource and Delegates
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("profileCellIdentifier")
        if indexPath.row == 0
        {
            tableViewCell?.textLabel?.text = userName
        }
        else if indexPath.row == 1
        {
            tableViewCell?.textLabel?.text = phNumber
        }
        else if indexPath.row == 2
        {
            tableViewCell?.textLabel?.text = gender
        }
        return tableViewCell!
    }

}
