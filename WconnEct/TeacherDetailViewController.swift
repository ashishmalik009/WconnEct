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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        experienceLabel.text = teacherToShowDetail.experience
        qualificationLabel.text = teacherToShowDetail.highestQualification
        aboutMeLabel.text = teacherToShowDetail.about_me

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
