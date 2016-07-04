//
//  ProfileUserParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 05/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class ProfileUserParser: NSObject
{
    var name : String = ""
    var contactNumber : String = ""
    var gender : String = ""
    func isparsedPRrofileUserUsingData(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSDictionary
            name = String(json.objectForKey("name")!)
            contactNumber = String(json.objectForKey("ph_number")!)
            gender = String(json.objectForKey("gender")!)
            
            
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }
}
