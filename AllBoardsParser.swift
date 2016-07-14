//
//  AllBoardsParser.swift
//  WconnEct
//
//  Created by Ashish Malik on 14/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class AllBoardsParser: NSObject
{
    var getBoard : (class:String,classId:Int) = ("",0)
    var getBoardAndBoardArray : [(_:String, _:Int)] = []
    func isParsedAllBoards(data: NSData) -> Bool
    {
        do
        {
            let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as!  NSArray
            for i in 0..<json.count
            {
                let eachObjectDictionary = json.objectAtIndex(i) as! NSDictionary
                let valueOfClass = eachObjectDictionary.objectForKey("board") as! String
                let classId = eachObjectDictionary.objectForKey("boardid") as! Int
                getBoard = (valueOfClass,classId)
                getBoardAndBoardArray.append(getBoard)
                
            }
            
        }
        catch
        {
            print("error serializing JSON: \(error)")
        }
        return true
    }


}
