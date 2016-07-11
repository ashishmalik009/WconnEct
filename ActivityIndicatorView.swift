//
//  ActivityIndicatorView.swift
//  WconnEct
//
//  Created by Ashish Malik on 11/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class ActivityIndicatorView: UIViewController
{
    
    func showView(message:String)
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
}
