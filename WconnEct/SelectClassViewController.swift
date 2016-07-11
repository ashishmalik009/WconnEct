//
//  SelectClassViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 11/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SelectClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var classTupleArray : [(class: String, classId: Int)] = []
    
    @IBOutlet weak var classTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.callClassData()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func callClassData()
    {
        let requestObject = RequestBuilder()
        let activityIndicator = ActivityIndicatorView()
        activityIndicator.showView("Fetching Classes")
//        showActivityIndicator("Fetching classes")
        requestObject.requestForAllClasses()
//        self.showActivityIndicator("Fetching Info..")
        requestObject.errorHandler = { error in
            
            self.dismissViewControllerAnimated(true, completion:nil)
            dispatch_async(dispatch_get_main_queue(),{
                let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            })
            
        }
        
        requestObject.completionHandler = { dataValue in
            self.dismissViewControllerAnimated(true, completion:nil)
            dispatch_async(dispatch_get_main_queue(), {
                let parser = AllClassesParser()
                if parser.isparsedAllClasses(dataValue)
                {
                    self.classTupleArray = parser.getClassAndClassIdArray
                    self.classTableView.reloadData()
                }
        })
            
        }

    }
    
    func showActivityIndicator(message:String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.classTupleArray.count
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectClassCellIdentifier", forIndexPath: indexPath)
        let classTuple = self.classTupleArray[indexPath.row]
        let  valueOfClass : String = classTuple.0
        cell.textLabel?.text = valueOfClass
        

        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if  tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
        else
        {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        self.navigationController?.popViewControllerAnimated(true)
    }



}
