//
//  SlideMenuDetailController.swift
//  WconnEct
//
//  Created by Ashish Malik on 06/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class SlideMenuDetailController: UIViewController, UITableViewDelegate, UITableViewDataSource, ClassValueDatasource, UIPageViewControllerDataSource
{
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    
    var selectedIndex : Int = 0
    var classIdOfSelectedClass : Int = 999
    var subjectIdOfSelectedSubject : Int = 999
    var boardIDofSelectedBoard : Int = 999
    var arrayValuesToShowInTable : NSMutableArray = ["Class","Subject"]
    let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
    let imagesArray  : NSArray = ["image1.jpg", "image2.jpg", "image3.jpg", "image4.jpg"]
    
    @IBOutlet weak var detailTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        pageViewController.dataSource = self
        let startingViewController : PageContentViewController = self.getViewControllerAtIndex(0)
        self.pageViewController.setViewControllers([startingViewController], direction: .Forward, animated: false, completion: nil)
        self.pageViewController.view.frame = CGRectMake(0, (self.navigationController?.navigationBar.frame.size.height)! , self.view.frame.size.width, self.view.frame.size.height - self.detailTableView.frame.size.height-(self.navigationController?.navigationBar.frame.size.height)! - (self.tabBarController?.tabBar.frame.size.height)!);
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        self.pageViewController.didMoveToParentViewController(self)
        
        
//        if revealViewController() != nil
//        {
//            //            revealViewController().rearViewRevealWidth = 62
//            menuButton.target = revealViewController()
//            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
//
//            
//            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
//            view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
//            
//        }
//        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        if classIdOfSelectedClass == 999 || subjectIdOfSelectedSubject == 999
        {
            doneButton.enabled = false
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "sendIDStoryboardSegue"
        {
            let teachersListController = segue.destinationViewController as? TeachersListViewController
            teachersListController?.classID = classIdOfSelectedClass
            teachersListController?.subjectID = subjectIdOfSelectedSubject
            teachersListController?.boardId = boardIDofSelectedBoard
            
            
        }
        else
        {
            let classController = segue.destinationViewController as! SelectClassViewController
            classController.selectedIndexFromDetailController = self.selectedIndex
            classController.selectedClassID = classIdOfSelectedClass
            classController.delegateOfClassValueController = self
        }
        
    }
    
     //MARK : ClassValueDataSource
    func getValueOfClassOrSubject(value : String,iD : Int,isClassSubjectOrBoard:Int)
    {
        let tableViewCell = self.detailTableView.cellForRowAtIndexPath(NSIndexPath(forRow: selectedIndex, inSection: 0))
        tableViewCell?.detailTextLabel?.text = value
        if isClassSubjectOrBoard == 1
        {
            if value == "1" || value == "2" || value == "3" || value == "4" || value == "5" || value == "6" || value == "7" || value == "8" || value == "9" || value == "10" || value == "11" || value == "12"
            {
                arrayValuesToShowInTable.addObject("Board")
                if arrayValuesToShowInTable.count == 3
                {
                    self.detailTableView.insertRowsAtIndexPaths([NSIndexPath.init(forRow: arrayValuesToShowInTable.count-1, inSection: 0)], withRowAnimation: .Automatic)
                }
            }
            else
            {
                arrayValuesToShowInTable.removeObject("Board")
                if arrayValuesToShowInTable.count == 2
                {
                    self.detailTableView.deleteRowsAtIndexPaths([NSIndexPath.init(forRow: arrayValuesToShowInTable.count, inSection: 0)], withRowAnimation: .Automatic)
                }
            }

            classIdOfSelectedClass = iD
            
        }
        else if isClassSubjectOrBoard == 2
        {
            subjectIdOfSelectedSubject = iD
            doneButton.enabled = true
        }
        else if isClassSubjectOrBoard == 3
        {
            boardIDofSelectedBoard = iD
        }

    }
   
    
    @IBAction func sendIDToNextController(sender: AnyObject)
    {
        self.performSegueWithIdentifier("sendIDStoryboardSegue", sender: self)
        
    }

    //MARK : PageViewControllerDatasource
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if ((index == 0) || (index == NSNotFound))
        {
            index = self.imagesArray.count
        }
        index -= 1;
        return getViewControllerAtIndex(index)
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
     
        let pageContent: PageContentViewController = viewController as! PageContentViewController
        var index = pageContent.pageIndex
        if (index == NSNotFound)
        {
            return nil;
        }

        index += 1;
        if (index == imagesArray.count)
        {
            index = 0
        }
        return getViewControllerAtIndex(index)
        
    }
    
    func getViewControllerAtIndex(index: NSInteger) -> PageContentViewController
    {
        print ("Index is \(index)")
        // Create a new view controller and pass suitable data.
        let pageContentViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageContentViewControllerID") as! PageContentViewController
        pageContentViewController.imageFile = "\(imagesArray[index])"
        pageContentViewController.pageIndex = index
        return pageContentViewController
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return imagesArray.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0 
    }
    //MARK : UitableViewDelegates and DataSources
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayValuesToShowInTable.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("detailCellIdentifier")
        if indexPath.row == 0
        {
            
            tableViewCell?.detailTextLabel?.text = "Select Class"
        }
        else if indexPath.row == 1
        {
            
            tableViewCell?.detailTextLabel?.text = "Select Subject"
        }
        else if indexPath.row == 2
        {
            tableViewCell?.detailTextLabel?.text = "Select Board"
        }
        tableViewCell?.textLabel?.text = String(arrayValuesToShowInTable.objectAtIndex(indexPath.row))
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
