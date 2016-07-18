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

    @IBOutlet weak var teachersTableView: UITableView!
    var classID : Int = 999
    var subjectID : Int = 999
    var boardId : Int = 999
    var teachersListArray : NSMutableArray = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
       print(classID)
        print(subjectID)
        print(boardId)
        
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.requestForTeachersList()
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
            
            dispatch_async(dispatch_get_main_queue(), {
                self.dismissViewControllerAnimated(true, completion:{ ()-> Void in
                let parser = TeachersListParser()
                if parser.isParsedTeachersList(dataValue)
                {
                    self.teachersListArray = parser.teachersArray
                    self.teachersTableView.reloadData()
                    
                }
                
            })
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
        return self.teachersListArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("teachersListCellIdentifier")! as! TeachersTableViewCell
        let teacher =  teachersListArray.objectAtIndex(indexPath.row) as! Teacher
        tableViewCell.nameLabel.text = teacher.name
        tableViewCell.qualificationLabel.text = teacher.highestQualification
        tableViewCell.experienceLabel.text = teacher.experience
        tableViewCell.profileImageView.layer.cornerRadius = tableViewCell.profileImageView.frame.size.width/2
        tableViewCell.profileImageView.clipsToBounds = true
        
        
        
        return tableViewCell
    }
}
