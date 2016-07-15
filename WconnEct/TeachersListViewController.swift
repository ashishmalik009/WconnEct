//
//  TeachersListViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 15/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//

import UIKit

class TeachersListViewController: UIViewController
{

    var classID : Int = 999
    var subjectID : Int = 999
    var boardId : Int = 999
    override func viewDidLoad()
    {
        super.viewDidLoad()
       print(classID)
        print(subjectID)
        print(boardId)
        
        self.requestForTeachersList()
        // Do any additional setup after loading the view.
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
            self.dismissViewControllerAnimated(true, completion:nil)
            dispatch_async(dispatch_get_main_queue(), {
//                let parser = AllClassesParser()
//                if parser.isparsedAllClasses(dataValue)
//                {
//                    self.valueTupleArray = parser.getClassAndClassIdArray
//                    self.classTableView.reloadData()
//                }
                
            })
            
        }

    }
    override func didReceiveMemoryWarning()
    {
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
