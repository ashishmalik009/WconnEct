//
//  SlideMenuDetailController.swift
//  WconnEct
//
//  Created by Ashish Malik on 06/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SlideMenuDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
     @IBOutlet var menuButton:UIBarButtonItem!
    var selectedIndex : Int = 0
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
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(selectedIndex)
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
    }

}
