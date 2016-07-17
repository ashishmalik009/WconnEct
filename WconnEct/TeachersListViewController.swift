//
//  TeachersListViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 15/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class TeachersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    var classID : Int = 999
    var subjectID : Int = 999
    var boardId : Int = 999
    override func viewDidLoad()
    {
        super.viewDidLoad()
       print(classID)
        print(subjectID)
        print(boardId)
        
        self.requestForTeachersList()
        // Do any additional setup after loading the view.
    }

    func requestForTeachersList()
    {
        self.showActivityIndicator()
        let requestObject = RequestBuilder()
        
        requestObject.requestForTeachersList(classID, subjectID: subjectID, boardID: boardId)
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
                let parser = TeachersListParser()
                if parser.isParsedTeachersList(dataValue)
                {
                    
                }
//                {
//                    self.valueTupleArray = parser.getClassAndClassIdArray
//                    self.classTableView.reloadData()
//                }
                
            })
            
        }

    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func showActivityIndicator()
    {
        let alert = UIAlertController(title: nil, message: "Fetching data...", preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
    }


    //MARK : TableViewDataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("teachersListCellIdentifier")! as UITableViewCell
        tableViewCell.textLabel?.text = "Ashish"
        return tableViewCell
    }
}
