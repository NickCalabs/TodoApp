//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Nick on 1/30/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
    //needed after conforming to NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        //step two for loading file
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        
        //step one
        super.init()
    }
    
    override init() {
        super.init()
    }
}