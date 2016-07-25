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
    
    
    func requestForSignUp(name:String,phNumber:String,emailID:String,password:String,gender:String,isTeacher:Bool,isGoogleOrFBSignUp :Bool) -> Void
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
        var post : String = ""
        if isGoogleOrFBSignUp
        {
            post = "name=\(name)&email=\(emailID)"
        }
        else
        {
            post = "name=\(name)&ph_number=\(String(phNumber))&email=\(emailID)&pswd=\(password)&gender=\(gender)"
            
        }
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
                    else
                    {
                        let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                        self.errorHandler(errorValue:responseError)
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
            if delegate.isTeacherLoggedIn
            {
                url = NSURL(string: "http://wconnect-pcj.rhcloud.com/teacher/\(delegate.accessTokenAfterLogin)")!
            }
            else
            {
                url = NSURL(string: "http://wconnect-pcj.rhcloud.com/student/\(delegate.accessTokenAfterLogin)")!
            }
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
//                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                    else
                    {
                        let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                        self.errorHandler(errorValue:responseError)
                    }
                }
                
            }
            
            
        })
        dataTask.resume()
    }
  
    func requestToUpdateData(tupleArrayReceived : [(_:String, _:String)]) -> Void
    {
        var isTeacher : Bool = true
        if let deleagte = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            if !deleagte.isTeacherLoggedIn
            {
                isTeacher = false
            }
        }
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
        let post : NSMutableString = ""
        if let delegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            post.appendString("token=\(delegate.accessTokenAfterLogin)")
        }
        for i in 0..<tupleArrayReceived.count
        {
            
               post.appendString("&\(tupleArrayReceived[i].0)=\(tupleArrayReceived[i].1)")
            
        }
        let postData : NSData = post.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let postLength: String = "\(postData.length)"
        request.HTTPMethod = "PUT"
        
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
                else
                {
                    let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                    self.errorHandler(errorValue:responseError)
                }
                
            }
            
            
        })
        
        dataTask.resume()
    }
    
    
    
    func requestForAllClasses()
    {
        var url = NSURL()
        url = NSURL(string: "http://wconnect-pcj.rhcloud.com/class/")!
        
        
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
//                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                    else
                    {
                        let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                        self.errorHandler(errorValue:responseError)
                    }
                }
                
            }
            
            
        })
        dataTask.resume()
    }

    func requestForSubjects(classID:Int)
    {
        var url = NSURL()
        url = NSURL(string: "http://wconnect-pcj.rhcloud.com/subject/?classid=\(classID)")!
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        print("SubjectListRequest : \(request)")
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
//                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                    else
                    {
                        let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                        self.errorHandler(errorValue:responseError)
                    }
                }
                
            }
            
            
        })
        
        dataTask.resume()
    }
    
    func requestForBoard()
    {
        var url = NSURL()
        url = NSURL(string: "http://wconnect-pcj.rhcloud.com/board/")!
        
        
        let request = NSMutableURLRequest(URL: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPMethod = "GET"
        print("Boards Request : \(request)")
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
//                        print(NSString(data: data!, encoding: NSUTF8StringEncoding))
                        self.completionHandler(dataFromServer: data!)
                        
                        
                    }
                    else
                    {
                        let responseError = NSError(domain: "Some error occured. Please try again later", code: 0, userInfo: nil)
                        self.errorHandler(errorValue:responseError)
                    }
                }
                
            }
            
            
        })
        dataTask.resume()

    }
    
    func requestForTeachersList(classId:Int, subjectID:Int, boardID:Int)
    {
        var url = NSURL()
        
        url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/teacher/?classid=\(classId)&subjectid=\(subjectID)&boardid=\(boardID)")!
        
        let request: NSMutableURLRequest = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
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
}


