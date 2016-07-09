//
//  UserProfileViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 08/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
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
                    self.dismissViewControllerAnimated(true, completion: nil)
                    //                            self.userName = parser.name
                    //                            self.phNumber = parser.contactNumber
                    //                            self.gender = parser.gender
                    //                            self.emailId = parser.email
                    //                            self.dismissViewControllerAnimated(true, completion: nil)
                    //                            self.userNameLabel.text = parser.name
                    //                            self.profileTableView.reloadData()
                }
            })
            
        }
        

    }
    
    @IBAction func cancel(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
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

  
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
