//
//  ViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 20/06/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class ViewController: UIViewController, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

