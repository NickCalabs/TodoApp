//
//  ViewController.swift
//  Checklists
//
//  Created by Nick on 1/25/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    /*
    @IBAction func addItem(){
        let newRowIndex = items.count
        let item = ChecklistItem()
        item.text = "I am a new row"
        item.checked = true
        items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    }*/
    
    //var items: [ChecklistItem] //remove this when changing the data model pg174
    
    //so we know which checklist we're viewing
    var checklist: Checklist!
    
    //remove this once we chnage the data model
    /*required init?(coder aDecoder: NSCoder){
        
        items = [ChecklistItem]()
        
        //for initialy creating dummy todo's
        /*let row0item = ChecklistItem()
        row0item.text = "Walk the dog"
        row0item.checked = false
        items.append(row0item)*/
        
        super.init(coder: aDecoder)
        
        //toload ish pg143
        loadChecklistItems()
        
        //after adding documentsDirectory and dataFilePath functions
        //print("Documents folder is \(documentsDirectory())")
        //print("Data file path is \(dataFilePath())")
    }*/
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //once we add AllLists this is so we knwo which checklist we're viewing
        title = checklist.name
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //after we implemented plist saving
        //saveChecklistItems()
    }
    
    func configureCheckmarkForCell(cell:UITableViewCell, withChecklistItem item: ChecklistItem){
        
        let label = cell.viewWithTag(1001) as! UILabel
        if item.checked{
            label.text = "√"
        } else {
            label.text = ""
        }
        
        //when checkmark is on right before changing the accesory from check to detail disclosure
        /*if item.checked{
            cell.accessoryType = .Checkmark
        } else {
            cell.accessoryType = .None
        }*/
        
        label.textColor = view.tintColor //color, obv
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item:ChecklistItem){
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //swipe to delete
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        checklist.items.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        //after we implemented plist saving
        //saveChecklistItems()
    }
    
    //implementations of protocol additem methods
    //delegate methods
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        //second step
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        //first step
        dismissViewControllerAnimated(true, completion: nil)
        
        //after we implemented plist saving
        //saveChecklistItems()
    }
    
    //adding this when added new editing protocol is ItemDetailViewController
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        if let index = checklist.items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
            }
        }
        dismissViewControllerAnimated(true, completion: nil)
        
        //after we implemented plist saving
        //saveChecklistItems()
    }
    
    //letting screen B know this screen (sceen A) is with its delegate //final step pg105
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
        //^get navigation controller from storyboard and its embedded itemDetailViewController using topViewController
        //^also get the view controller's delegate property so you're notified when the user taps cancel or done 
        
        //change this after adding the itemToEdit
        /*if segue.identifier == "AddItem"{
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        }*/
    }
    
    //for saving data pg128
    //remove saving file methods when changing data model. the Checklist object will take this responsiblity. belongs to data model, not controller
    /*func documentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths[0]
    }
    
    func dataFilePath() -> String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plist")
        //or
        //let directory = documentsDirectory() as NSString
        //return directory.stringByAppendingPathComponent("Checlists.plist")
    }
    
    func saveChecklistItems() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)
    }
    
    func loadChecklistItems(){
        let path = dataFilePath()
        
        //makes sure there is somethign, if not, nothign exectuted
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
            
            //revrese of saveChecklistItems() - load entire array and its contents from file
            if let data = NSData(contentsOfFile: path){
                let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
                items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
                unarchiver.finishDecoding()
            }
        }
    }*/

}

