//
//  RequestBuilder.swift
//  WconnEct
//
//  Created by Ashish Malik on 03/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class RequestBuilder: NSObject
{
    typealias CompletionHandler = (dataFromServer : NSData) -> Void
    
    func requestForSignUp(name:String ,phNumber:String,emailID:String,password:String,gender:String,photo:String,isTeacher:Bool) -> Void
    {
        var url = NSURL()
        if isTeacher
        {
             url = NSURL.init(string: "http://wconnect-pcj.rhcloud.com/teacher/")!
        }
        else
        {
            url = NSURL.init(string: "http://wconnect-pcj.rhcloud.com/student/")!
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let post : String = "name=\(name)&ph_number=\(String(phNumber))&email=\(emailID)&pswd=\(password)&photo=\(photo)&gender=\(gender)"
        let postData : NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        request.HTTPMethod = "POST"
        
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            if error != nil
            {
                
            }
            if let httpResponse = response as? NSHTTPURLResponse
            {
                if httpResponse.statusCode == 200
                {
                    print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                   
                    
                }
            }
            
            
        })
        
        dataTask.resume()
        

    }
}
