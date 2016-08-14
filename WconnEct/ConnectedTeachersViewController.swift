//
//  ConnectedTeachersViewController.swift
//  WconnEct
//
//  Created by Anahita Kapoor on 23/05/1938 Saka.
//  Copyright © 1938 Saka wconnect. All rights reserved.
//

import UIKit

class ConnectedTeachersViewController: UIViewController {

    @IBOutlet var testView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer : CALayer = self.testView.layer
        layer.shadowOffset = CGSizeMake(1, 1)
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.80
        let bezierPath = UIBezierPath(rect: layer.bounds)
        layer.shadowPath = bezierPath.CGPath
        layer.masksToBounds = false
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
