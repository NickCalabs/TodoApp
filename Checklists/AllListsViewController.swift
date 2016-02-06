//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Nick on 2/1/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {
    
    //var lists: [Checklist] //remove this once we create DataModel
    var dataModel: DataModel! //create this once we create DataModel //datamodel will be nil for a sec so ! is needed
    //^^after creating DataModel we need to change all references to lists -> dataModel.lists
    
    //remove this once we create DataModel
    /*required init?(coder aDecoder: NSCoder) {
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        
        loadChecklists()
        
        //for fake data purposes
        /*var list = Checklist(name: "Birthdays")
        lists.append(list)
        
        list = Checklist(name: "Groceries")
        lists.append(list)
        
        list = Checklist(name: "Cool Apps")
        lists.append(list)
        
        list = Checklist(name: "To Do")
        lists.append(list)
        
        //faking data
        for list in lists {
            let item = ChecklistItem()
            item.text = "Item for \(list.name)"
            list.items.append(item)
        }*/
    }*/

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = cellForTableView(tableView)
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining" //created with .Subtitle in cellForTableView
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "(No Items)"
        } else if count == 0 {
            cell.detailTextLabel!.text = "All Done!"
        } else {
            cell.detailTextLabel!.text = "\(count) Remaining"
        }
        
        //this line just to fill and test with data
        //cell.textLabel!.text = "List \(indexPath.row)"
        
        cell.imageView!.image = UIImage(named: checklist.iconName) //add this for displaying image - .Subtitle comes with an image view
        
        return cell
    }
    
    //helper method since we're creating the cell in tableView(cellForRowAtIndexPath) in code instead of interface builder
    func cellForTableView(tableView: UITableView) -> UITableViewCell{
        let cellIdentifer = "Cell"
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifer){
            return cell
        } else {
            return UITableViewCell(style: .Subtitle, reuseIdentifier: cellIdentifer) //change style from .Default to .Subtitle and create detailTextLabel in cellForRowAtIndexPath
        }
    }
    
    //for when we created the segue identifer going from AllList to Name of Checklist
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //add this line for when we add the index into userdefaults
        //NSUserDefaults.standardUserDefaults().setInteger(indexPath.row, forKey: "ChecklistIndex")
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        //give Checklist object to the checklistviewcontroller when the segue is performed
        let checklist = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
        
        //1
        //must program the segue to start when you tap a row becuase there is no prototype cell to connect the screen to this time
        //performSegueWithIdentifier("ShowChecklist", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowChecklist"{
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            
            controller.delegate = self
            controller.checklistToEdit = nil
        }
        
        //1
        /*if segue.identifier == "ShowChecklist"{
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist
        }*/
    }
    
    //delegate methods
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        
        //remove block once we implement sort array. since we now do reloadData on the tableview
        /*let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)*/
        
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        
        tableView.reloadData()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist) {
        
        //remove block once we implement sort array
        /*if let index = dataModel.lists.indexOf(checklist){
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }*/
        
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //alows user to delete checklists
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }
    
    
    //opening from accesorry button without a segue
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        controller.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //saving data (same as in ChecklistViewController)
    //load and save lists array instead of items array
    //cut all these once we create DataModel that will be handling all the save/loading
    /*func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
    }
    
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(lists, forKey: "Checklists")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklists() {
        let path = dataFilePath()
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            if let data = NSData(contentsOfFile: path) {
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
                unarchiver.finishDecoding()
            }
        }
    }*/
    
    //for saving nsuserdefualts when the backbutton is pressed and the alllists is the main view
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self{
            //NSUserDefaults.standardUserDefaults().setInteger(-1, forKey: "ChecklistIndex")
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    //check at startup which checklist yo need to show and perform segue manualy
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        //let index = NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        let index = dataModel.indexOfSelectedChecklist //after creating get computed property in DataModel
        
        //checks to be sure the number is 0, -1 or between the amount of numbers in the index
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
    }
    
    //adding this instead of a delegate to have the subtitle update the remaining area
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
}






