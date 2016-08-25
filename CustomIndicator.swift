//
//  CustomIndicator.swift
//  WconnEct
//
//  Created by Ashish Malik on 25/08/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class CustomIndicator
{
    static let sharedInstance = CustomIndicator()
    
    func showActivityIndicator(message : String) -> UIAlertController
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        return alert
    }
}
