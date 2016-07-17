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
                teacher.iD = dict.objectForKey("teacherid") as! Int
                teacher.contactNumber = String(dict.objectForKey("ph_number")!)
                teacher.emailID = String(dict.objectForKey("email")!)
                teacher.dateOfBirth = String(dict.objectForKey("dob")!)
                teacher.gender = String(dict.objectForKey("gender")!)
                teacher.highestQualification = String(dict.objectForKey("highest_qualification")!)
                teacher.experience = String(dict.objectForKey("experience")!)
                teacher.profession = String(dict.objectForKey("profession")!)
                teacher.about_me = String(dict.objectForKey("about_me"))
                teachersArray.addObject(teacher)
                
            }
            
            
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }
}
