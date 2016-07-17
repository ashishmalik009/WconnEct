//
//  TeachersListParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 17/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class TeachersListParser: NSObject
{
    let teachersArray : NSMutableArray = []
    let teacher = Teacher()
    
    func isParsedTeachersList(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSArray
            for i in 0..<json.count
            {
                let dict =  json.objectAtIndex(i) as! NSDictionary
                teacher.name = String(dict.objectForKey("name")!)
                print(teacher.name)
                
            }
            
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }
}
