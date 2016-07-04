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
    var completionHandler: (dataFromServer: NSData) -> Void =  {dataValue in }
    var errorHandler : (errorValue : NSError) -> Void = { errorFromServer in }
    override init()
    {
        super.init()
    }
    
    
    func requestForSignUp(name:String ,phNumber:String,emailID:String,password:String,gender:String,photo:String,isTeacher:Bool) -> Void
    {
        var url = NSURL()
        if isTeacher
        {
             url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/teacher/")!
        }
        else
        {
            url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/student/")!
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let post : String = "name=\(name)&ph_number=\(String(phNumber))&email=\(emailID)&pswd=\(password)&photo=\(photo)&gender=\(gender)"
        let postData : NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        request.HTTPMethod = "POST"
        
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        print("SignupRequest : \(request)")
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
                    self.completionHandler(dataFromServer: data!)
                   
                    
                }
            }
            
            
        })
        
        dataTask.resume()
    }
    
    
    func requestForLogIn(emailId:String ,password:String,isTeacher:Bool) -> Void
    {
        var url = NSURL()
        if isTeacher
        {
            url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/teacher/login/")!
        }
        else
        {
            url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/student/login/")!
        }
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        let post : String = "email=\(emailId)&pswd=\(password)"
        let postData : NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        request.HTTPMethod = "POST"
        
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        print("LoginRequest : \(request)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let session = NSURLSession.sharedSession()
        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            if error != nil
            {
                self.errorHandler(errorValue: error!)
            }
            else
            {
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    if httpResponse.statusCode == 200
                    {
                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                }

            }
            
            
        })
        
        dataTask.resume()
    }
    
    func requestForProfileOfUser()
    {
        var url = NSURL()
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            url = NSURL(string: "http://wconnect-pcj.rhcloud.com/student/\(delegate.accessTokenAfterLogin)")!
        }
        
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "GET"
        print("Profile Request : \(request)")
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let urlsession = NSURLSession.sharedSession()
        
        let dataTask : NSURLSessionDataTask = urlsession.dataTaskWithRequest(request, completionHandler: {
            
            data, response, error in
            
            dispatch_async(dispatch_get_main_queue()) {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
            if error != nil
            {
                self.errorHandler(errorValue: error!)
            }
            else
            {
                if let httpResponse = response as? NSHTTPURLResponse
                {
                    if httpResponse.statusCode == 200
                    {
                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                }
                
            }
            
            
        })
        dataTask.resume()
    }
    
}
