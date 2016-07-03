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
    var errorFromParser : String = ""
    
    func isparsedSignUpDetailsUsingData(data: NSData) -> Bool
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
                errorFromParser = String(messageInErrors.objectForKey("message")!)
                
                
                return false
            }
            //            for name in json
            //            {
            //                print(name["ph_number"])
            //                if let phNumber = name["ph_number"]
            //                {
            //                    print(phNumber)
            //                }
            //            }
            //            print(json)
            
        }catch{
            print("error serializing JSON: \(error)")
        }

        return true
    }

}
