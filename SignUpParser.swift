//
//  SignUpParser.swift
//  WconnEct
//
//  Created by Anahita Kapoor on 12/04/1938 Saka.
//  Copyright © 1938 Saka wconnect. All rights reserved.
//

import UIKit

class SignUpParser: NSObject
{
    var messageFromParser : String = ""
    
    func isparsedSignUpDetailsUsingData(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSDictionary
            let status = json.objectForKey("status") as! NSNumber
            if status == 1
            {
                messageFromParser = json.objectForKey("message") as! String
                
                
                return false
            }
            else if status == 0
            {
                messageFromParser = json.objectForKey("message") as! String
            }
            
        }catch{
            print("error serializing JSON: \(error)")
        }

        return true
    }
    
    

}
