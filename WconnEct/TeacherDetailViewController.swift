//
//  TeacherDetailViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 10/08/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class TeacherDetailViewController: UIViewController {

    var teacherToShowDetail = Teacher()
    @IBOutlet weak var experienceLabel: UILabel!
    
    @IBOutlet weak var qualificationLabel: UILabel!
    @IBOutlet weak var aboutMeLabel: UILabel!
    
    @IBOutlet weak var imageViewForProfile : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.imageViewForProfile.layer.cornerRadius = self.imageViewForProfile.frame.size.width / 2
        self.imageViewForProfile.clipsToBounds = true
//        experienceLabel.text = teacherToShowDetail.experience
//        qualificationLabel.text = teacherToShowDetail.highestQualification
        aboutMeLabel.text = teacherToShowDetail.about_me

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("teacherDetailCellID") as! TeacherDetailTableViewCell
        let border = CALayer()
        border.frame = CGRectMake(0, 0, 1.0, CGRectGetHeight(cell.frame))
        border.backgroundColor = UIColor.blackColor().CGColor
        cell.viewForTeacherDetail.layer.addSublayer(border)
        cell.viewForTeacherDetail.layer.cornerRadius = 20.0

//        cell.textLabel?.text = "Ashish"
        return cell
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0
        {
            return "EDUCATIONS AND QUALIFICATIONS"
        }
        else if section == 1
        {
            return "EXPERIENCE"
        }
        else if section == 2
        {
            return "CERTIFICATES AND AWARDS"
        }
        else if section == 3
        {
            return "SPECIALITY"
        }
        
        return ""
    }

}
