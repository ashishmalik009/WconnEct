//
//  SlideMenuDetailController.swift
//  WconnEct
//
//  Created by Ashish Malik on 06/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SlideMenuDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassValueDatasource
{
     @IBOutlet var menuButton:UIBarButtonItem!
    var selectedIndex : Int = 0
    var classIdOfSelectedClass : Int = 999
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        if revealViewController() != nil
        {
            //            revealViewController().rearViewRevealWidth = 62
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))

            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            
        }
        
        
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        let classController = segue.destinationViewController as! SelectClassViewController
        classController.selectedIndexFromDetailController = self.selectedIndex
        classController.selectedClassID = classIdOfSelectedClass
        classController.delegateOfClassValueController = self
        
    }
    
    //MARK : ClassValueDataSource
    func getValueOfClasse(value: String, iD: Int)
    {
        let tableViewCell = self.detailTableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
        tableViewCell?.detailTextLabel?.text = value
        classIdOfSelectedClass = iD
    
        
    }
    //MARK : UitableViewDelegates and DataSources
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("detailCellIdentifier")
        if indexPath.row == 0
        {
            tableViewCell?.textLabel?.text = "Class"
            tableViewCell?.detailTextLabel?.text = "Select Class"
        }
        else if indexPath.row == 1
        {
            tableViewCell?.textLabel?.text = "Subject"
            tableViewCell?.detailTextLabel?.text = "Select Subject"
        }
        else if indexPath.row == 2
        {
            tableViewCell?.textLabel?.text = "Board/University"
            tableViewCell?.detailTextLabel?.text = "Select Board/University"
        }
        return tableViewCell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row == 0
        {
            self.performSegueWithIdentifier("seguetoSelectClass", sender: self)
        }
        else if classIdOfSelectedClass == 999
        {
            let alert = UIAlertController(title: "WconnEct", message: "Please select class to continue", preferredStyle: .Alert)
            let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(alertAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        else
        {
            self.performSegueWithIdentifier("seguetoSelectClass", sender: self)
        }
    }

}
