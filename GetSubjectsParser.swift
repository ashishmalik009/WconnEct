//
//  GetSubjectsParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 13/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class GetSubjectsParser: NSObject
{
    var getSubjects : (subject:String,subjectId:Int) = ("",0)
    var getSubjectAndSubjectIdArray : [(_:String, _:Int)] = []
    
    func isparsedAllSubjects(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSArray
            for i in 0..<json.count
            {
                let eachObjectDictionary = json.objectAtIndex(i) as! NSDictionary
                let valueOfClass = eachObjectDictionary.objectForKey("subject") as! String
                let classId = eachObjectDictionary.objectForKey("subjectid") as! Int
                getSubjects = (valueOfClass,classId)
                getSubjectAndSubjectIdArray.append(getSubjects)
                
            }
            
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }


}
