//
//  AllClassesParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 11/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class AllClassesParser: NSObject
{
    var getClass : (class:String,classId:Int) = ("",0)
    var getClassAndClassIdArray : [(class:String, classId:Int)] = []
    func isparsedAllClasses(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSArray
            for i in 0..<json.count
            {
                let eachObjectDictionary = json.objectAtIndex(i) as! NSDictionary
                let valueOfClass = eachObjectDictionary.objectForKey("class") as! String
                let classId = eachObjectDictionary.objectForKey("classid") as! Int
                getClass = (valueOfClass,classId)
                getClassAndClassIdArray.append(getClass)
                
            }
           
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }

}
