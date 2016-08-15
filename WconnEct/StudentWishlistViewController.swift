//
//  StudentWishlistViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 15/08/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit
import CoreLocation

class StudentWishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var wishlistTableView: UITableView!

    var studentWishlistArray : NSMutableArray = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        CustomActivityIndicator.sharedInstance.showActivityIndicator(self.view)
        let request = RequestBuilder()
        request.getStudentWishlist()
        request.completionHandler =
            {
                dataValue in
                dispatch_async(dispatch_get_main_queue(),{
                    
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                    let parser = TeachersListParser()
                    if parser.isParsedTeachersList(dataValue)
                    {
                        self.studentWishlistArray = parser.teachersArray
                        self.wishlistTableView.reloadData()
                    }
                })
        }
        
        request.errorHandler =
            { errorValue in
                dispatch_async(dispatch_get_main_queue(),{
                    
                    CustomActivityIndicator.sharedInstance.hideActivityIndicator(self.view)
                })
        }
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
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentWishlistArray.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("teachersListCellIdentifier") as! TeachersTableViewCell
        
        let teacher =  studentWishlistArray.objectAtIndex(indexPath.row) as! Teacher
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
