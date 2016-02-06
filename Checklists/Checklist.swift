//
//  Checklist.swift
//  Checklists
//
//  Created by Nick on 2/1/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding /*add nscoding once we make this load and save to and from the file*/ {
    var name = ""
    
    var items = [ChecklistItem]() //begin changing the data model to have each Checklist object poitn to a diffent array of items
    
    var iconName: String //Add this for icons
    
    //init method to make name required
    //remove and create new init pg228
    /*init(name: String){
        self.name = name
        iconName = "No icon" //added with icons, must have a value, not an optional //Change from "Appintments" to test to No Icon
        super.init()
    }*/
    
    init(name: String, iconName: String){
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    convenience init(name: String){
        self.init(name: name, iconName: "NoIcon")
    }
    
    
    
    //add to satisfy the NSCoding protocol
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
        iconName = aDecoder.decodeObjectForKey("IconName") as! String //must add for every new property
        super.init()
    }
    
    //loads and saves Checklist's name and items properties
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
        aCoder.encodeObject(iconName, forKey: "IconName") //must add for every new property to save to plist (this is the images icons)
    }
    
    //counting items to display on cell
    func countUncheckedItems() -> Int{
        var count = 0
        for item in items where !item.checked{
            count += 1
        }
        return count
    }
}
    