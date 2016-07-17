//
//  SelectClassViewController.swift
//  WconnEct
//
//  Created by Ashish Malik on 11/07/16.
//  Copyright © 2016 wconnect. All rights reserved.
//


enum isClassSubjectorBoardID : Int {
    case isClass = 1,
         isSubject,
         isBoard
    
}
import UIKit
protocol ClassValueDatasource
{
    func getValueOfClassOrSubject(value : String,iD : Int,isClassSubjectOrBoard:Int)
}

class SelectClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var valueTupleArray : [(_: String, _: Int)] = []
    var selectedIndexFromDetailController : Int = 999
    var delegateOfClassValueController: ClassValueDatasource?
    var selectedClassID : Int = 999
    
    @IBOutlet weak var classTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        if selectedIndexFromDetailController == 0
        {
            showActivityIndicator("Fetching classes...")
        }
        else if selectedIndexFromDetailController == 1
        {
            showActivityIndicator("Fetching subjects...")
        }
        else if selectedIndexFromDetailController == 2
        {
            showActivityIndicator("Fetching Data...")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(true)
        if self.selectedIndexFromDetailController == 0
        {
            self.callClassData()
        }
        else if self.selectedIndexFromDetailController == 1
        {
            //Get Subjects for selected Class
            self.callSubjectData()
        }
        else
        {
            self.callBoardsData()
        }
    }
    func callClassData()
    {
        let requestObject = RequestBuilder()
        
        requestObject.requestForAllClasses()
        requestObject.errorHandler = { error in
            
            
            
            dispatch_async(dispatch_get_main_queue(),{
                self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
            
            })
            })
        }
        
        requestObject.completionHandler = { dataValue in
            
            dispatch_async(dispatch_get_main_queue(), {
                 self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                let parser = AllClassesParser()
                if parser.isparsedAllClasses(dataValue)
                {
                    self.valueTupleArray = parser.getClassAndClassIdArray
                    self.classTableView.reloadData()
                }
        
            })
            })
        }

    }
    func callSubjectData()
    {
        let requestObject = RequestBuilder()
        
        requestObject.requestForSubjects(selectedClassID)
        requestObject.errorHandler = { error in
            
                dispatch_async(dispatch_get_main_queue(),{
                     self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                    let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                    let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                    alert.addAction(alertAction)
                    self.presentViewController(alert, animated: true, completion: nil)
                
            })
            })
        }
        
        requestObject.completionHandler = { dataValue in
            
                dispatch_async(dispatch_get_main_queue(), {
                     self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                    let parser = GetSubjectsParser()
                    if parser.isparsedAllSubjects(dataValue)
                    {
                        self.valueTupleArray = parser.getSubjectAndSubjectIdArray
                        self.classTableView.reloadData()
                    }
                
            })
            })
        }

    }
    func callBoardsData()
    {
        let requestObject = RequestBuilder()
        
        requestObject.requestForBoard()
        requestObject.errorHandler = { error in
            
            
            dispatch_async(dispatch_get_main_queue(),{
                 self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                let alert = UIAlertController(title: "Error", message:error.description, preferredStyle:.Alert)
                let alertAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(alertAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
            })
            })
        }
        
        requestObject.completionHandler = { dataValue in
            
            dispatch_async(dispatch_get_main_queue(), {
                 self.dismissViewControllerAnimated(true, completion:{ () -> Void in
                let parser = AllBoardsParser()
                if parser.isParsedAllBoards(dataValue)
                {
                    self.valueTupleArray = parser.getBoardAndBoardArray
                    self.classTableView.reloadData()
                }
                
            })
            })
        }

    }
    func showActivityIndicator(message:String)
    {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        
        alert.view.tintColor = UIColor.blackColor()
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        loadingIndicator.startAnimating()
        
        alert.view.addSubview(loadingIndicator)
        presentViewController(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Table view data source
    
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.valueTupleArray.count
    }

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("selectClassCellIdentifier", forIndexPath: indexPath)
        let classTuple = self.valueTupleArray[indexPath.row]
        let  valueOfClass : String = classTuple.0
        cell.textLabel?.text = valueOfClass
        

        return cell
    }
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let classTuple = self.valueTupleArray[indexPath.row]
        let  valueOfClass : String = classTuple.0
        let iDOfClass : Int = classTuple.1
        if selectedIndexFromDetailController == 0
        {
                self.delegateOfClassValueController?.getValueOfClassOrSubject(valueOfClass, iD: iDOfClass, isClassSubjectOrBoard: isClassSubjectorBoardID.isClass.rawValue)
        }
        else if selectedIndexFromDetailController == 1
        {
            self.delegateOfClassValueController?.getValueOfClassOrSubject(valueOfClass, iD: iDOfClass, isClassSubjectOrBoard: isClassSubjectorBoardID.isSubject.rawValue)
        }
        else
        {
            self.delegateOfClassValueController?.getValueOfClassOrSubject(valueOfClass, iD: iDOfClass, isClassSubjectOrBoard: isClassSubjectorBoardID.isBoard.rawValue)
        }
        
        if  tableView.cellForRowAtIndexPath(indexPath)?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.None
        }
        else
        {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
        }
        self.navigationController?.popViewControllerAnimated(true)
    }



}
