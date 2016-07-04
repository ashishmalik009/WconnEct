//
//  LogInParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 04/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class LogInParser: NSObject
{

    var messageFromParser : String = ""
    
    func isparsedLogInDetailsUsingData(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSDictionary
            let status = json.objectForKey("status") as! NSNumber
            if status == 1
            {
                let message = json.objectForKey("message") as! NSDictionary
                let errors = message.objectForKey("errors") as! NSArray
                let messageInErrors = errors.objectAtIndex(0) as! NSDictionary
                messageFromParser = String(messageInErrors.objectForKey("message")!)
                
                
                return false
            }
            else if status == 0
            {
                let message = json.objectForKey("message") as! NSDictionary
                messageFromParser = String(message.objectForKey("message")!)
                if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
                {
                    delegate.accessTokenAfterLogin = String(message.objectForKey("token")!)
                }
                
            }
            else if status == 2
            {
                let message = json.objectForKey("message") as! String
                messageFromParser = message
                return false
            }
            
        }catch{
            print("error serializing JSON: \(error)")
        }
        
        return true
    }
    

}
