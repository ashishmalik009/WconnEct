//
//  TeachersListViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 15/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit
import CoreLocation

class TeachersListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    @IBOutlet weak var teachersTableView: UITableView!
    @IBOutlet weak var labelForNoData : UILabel!
    var classID : Int = 999
    var subjectID : Int = 999
    var boardId : Int = 999
    var selectedIndexPath : Int = 999
    var teachersListArray : NSMutableArray = []
    override func viewDidLoad()
    {
        super.viewDidLoad()
       print(classID)
        print(subjectID)
        print(boardId)
        self.labelForNoData.hidden = true
        
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(true)
         self.showActivityIndicator()
        
    }
    func requestForTeachersList()
    {
       
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
                    if self.teachersListArray.count == 0
                    {
                        self.teachersTableView.hidden = true
                        self.labelForNoData.hidden = false
                        self.labelForNoData.text = "Oops, no teachers found!!!"
                    }
                    else
                    {
                        self.teachersTableView.hidden = false
                        self.labelForNoData.hidden = true
                        self.teachersTableView.reloadData()
                    }
                    
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
        presentViewController(alert, animated: true, completion: { () -> Void in
            self.requestForTeachersList()
        })
        
    }
    
    func imageForRating(rating:Int) -> UIImage
    {
        switch(rating)
        {
            case 1: return UIImage.init(named:"1StarSmall.png")!
            case 2: return UIImage.init(named:"2StarsSmall.png")!
            case 3: return UIImage.init(named:"3StarsSmall.png")!
            case 4: return UIImage.init(named:"4StarsSmall.png")!
            case 5: return UIImage.init(named:"5StarsSmall.png")!
            default: print("No Stars")
        }
     return UIImage.init()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetailTeacherID"
        {
            let teacherDetailViewController = segue.destinationViewController as? TeacherDetailViewController
            teacherDetailViewController?.teacherToShowDetail = self.teachersListArray.objectAtIndex(selectedIndexPath) as! Teacher
            
        
        }
    }

    //MARK : TableViewDataSource and Delegates
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.teachersListArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("teachersListCellIdentifier")! as! TeachersTableViewCell
        let teacher =  teachersListArray.objectAtIndex(indexPath.row) as! Teacher
        tableViewCell.nameLabel.text = teacher.name
        tableViewCell.qualificationLabel.text = teacher.highestQualification
        tableViewCell.experienceLabel.text = teacher.experience
        tableViewCell.profileImageView.layer.cornerRadius = tableViewCell.profileImageView.frame.size.width/2
        tableViewCell.profileImageView.clipsToBounds = true
        tableViewCell.ratingImageView.image = self.imageForRating(Int(teacher.rating))
        tableViewCell.addToWishListButton.addTarget(self, action: #selector(TeachersListViewController.addToWishlist(_:)), forControlEvents: .TouchUpInside)
        if tableViewCell.addedToWishList
        {
            tableViewCell.addToWishListButton.setImage(UIImage(named: "addedToWishlist"), forState: .Normal)
        }
        else
        {
            tableViewCell.addToWishListButton.setImage(UIImage(named: "addToWishlist"), forState: .Normal)
        }
        if let appdelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        {
            let studentlocation = CLLocation(latitude: appdelegate.myLatitude, longitude:appdelegate.myLongitude)
            print("Latitude Student : \(appdelegate.myLatitude) + Long: \(appdelegate.myLongitude)")
            let teacherlocation = CLLocation(latitude: teacher.latitude, longitude:teacher.longitude)
            print("Latitude Student : \(teacher.latitude) + Long: \(teacher.longitude)")
            let distanceBetween: CLLocationDistance =
                        studentlocation.distanceFromLocation(teacherlocation)/1000
            let distanceInKm : CLLocationDistance =  distanceBetween
            
            tableViewCell.distanceLabel.text = String(format: "%.2fKM", distanceInKm)
            
        
            
        }
        
        return tableViewCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndexPath = indexPath.row
        self.performSegueWithIdentifier("showDetailTeacherID", sender: self)
        
    }

    func addToWishlist(sender:UIButton)
    {
      //  let buttonTag = sender.tag
        let buttonPosition = sender.convertPoint(CGPointZero, toView: self.teachersTableView)
        let buttonIndexPath = self.teachersTableView.indexPathForRowAtPoint(buttonPosition)
        let cell = self.teachersTableView.cellForRowAtIndexPath(buttonIndexPath!) as! TeachersTableViewCell
        let teacher =  teachersListArray.objectAtIndex(buttonIndexPath!.row) as! Teacher
        if cell.addedToWishList
        {
            cell.addedToWishList = false
            let request = RequestBuilder()
            print(teacher.iD)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                request.deleteTeacherToWishlist(teacher.iD)
                
                
            })

            cell.addToWishListButton.setImage(UIImage(named: "addToWishlist"), forState: .Normal)
        }
        else
        {
            cell.addedToWishList = true
            let request = RequestBuilder()
            print(teacher.iD)
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            request.addTeacherToWishlist(teacher.iD)    
                
            })
            
            cell.addToWishListButton.setImage(UIImage(named: "addedToWishlist"), forState: .Normal)
        }
    }
}
