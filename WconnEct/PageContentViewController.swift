//
//  PageContentViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 27/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class PageContentViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    var pageIndex : Int = 999
    var titleText : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
