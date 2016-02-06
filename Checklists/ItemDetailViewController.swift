//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Nick on 1/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation
import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    
    //for making the data model replace the cell when editing, not adding a new one
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //adding this when adding itemToEdit
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit{
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true //since it's false in the other one so you can't 'done' an empty item
        }
    }
    
    @IBAction func cancel(){
        //when user taps cancel you send the itemDetailViewControllerDidCancel() message back to the delegate
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done(){
        
        //checks if itemToEdit contains an object
        //if !nil put text from ChecklistItem and call delegate
        //if nil, user is adding new item
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
        
        //starting 2
        /*let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        
        //pass along a new checklistitem obbject that has the text string from the text field pg 105 steps 1-4
        delegate?.itemDetailViewController(self, didFinishAddingItem: item)*/
        
        //starting 1
        //before adding the delegate. this just prints to the console and dismisses the view.
        //print("contents: \(textField.text!)")
        //dismissViewControllerAnimated(true, completion: nil)
    }
    
    //disable selection for rows
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    //make keyboard automatically popup 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
        //simpler way below
        /*if newText.length > 0{
            doneBarButton.enabled = true
        } else {
            doneBarButton.enabled = false
        }*/
        
        doneBarButton.enabled = (newText.length > 0)
        
        return true
    }
    
}