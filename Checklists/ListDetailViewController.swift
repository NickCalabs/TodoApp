//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Nick on 2/1/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var iconImageView: UIImageView! //added with icons
    
    @IBAction func cancel(){
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            checklist.iconName = iconName //add this with new icon view
            delegate?.listDetailViewController(self, didFinishEditingChecklist: checklist)
        } else {
            //let checklist = Checklist(name: textField.text!)
            //checklist.iconName = iconName //add this with new icon view
            //replace these two lines with 
            let checklist = Checklist(name: textField.text!, iconName: iconName) //also change checklists.swift
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    var iconName = "Folder" //adding this when we create the icon selection cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
            
            iconName = checklist.iconName //add this when we add iconName property
        }
        iconImageView.image = UIImage(named: iconName) //also add this when we add iconName prop
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        if indexPath.section == 1{
            return indexPath
        } else {
            return nil
        }
        
        //return nil //prevents user from selecting the cell that they should be only typing in - change once we add icon cell
    }
    
    //enable/disable done button depending on if the user types or not 
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        doneBarButton.enabled = (newText.length > 0)
        return true
    }
    
    //add this for icons vc
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "PickIcon" {
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self //be sure to make vc conform to IconPickerViewControllerDelegate
        }
    }
    
    //adding this for the iconpickervcdelegate as well
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        self.iconName = iconName
        iconImageView.image = UIImage(named: iconName)
        navigationController?.popViewControllerAnimated(true)
    }
}

//same as what we did in itemdetailviewcontroller