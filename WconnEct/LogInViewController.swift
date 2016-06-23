//
//  LogInViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 21/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, NSURLConnectionDataDelegate {

    var data : NSMutableData = NSMutableData()
    let url = NSURL.init(string: "https://wconnect-pcj.rhcloud.com/teacher/")
    
    @IBAction func logIn(sender: AnyObject)
    {
        let request: NSURLRequest = NSURLRequest(URL: url!)
//        request.HTTPMethod = "POST"
        
//        let connection = NSURLConnection(request: request, delegate:self, startImmediately: true)
        let session = NSURLSession.sharedSession()
        let dataTask : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {
            (let data, let response, let error) in
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
            self.parseData(data!)
            })
        
        dataTask.resume()
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {(response, data, error) in
//            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
    }

    func parseData(data : NSData) -> Void {
        do
        {
            var json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [[String:AnyObject]]
            for name in json
            {
                print(name["ph_number"])
                if let phNumber = name["ph_number"]
                {
                    print(phNumber)
                }
            }
            print(json)
            
        }catch{
            print("error serializing JSON: \(error)")
        }

    }
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        print(NSString(data: data, encoding: NSUTF8StringEncoding))
        do
        {
            var json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as! [[String:AnyObject]]
            for name in json
            {
                print(name["ph_number"])
            if let phNumber = name["ph_number"]
            {
                print(phNumber)
                }
            }
            print(json)
          
        }catch{
            print("error serializing JSON: \(error)")
        }
    }
}
    

    

