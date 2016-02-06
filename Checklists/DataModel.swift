//
//  DataModel.swift
//  Checklists
//
//  Created by Nick on 2/2/16.
//  Copyright © 2016 Nick. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init(){
        //this makes sure that as soon as the datamodel object is created it will attmept to load checklists.plist
        //delcaration of lists already includes an initial value so you dont ned to init it 
        //also, no super init() becuase DataModel has no superclass
        loadChecklists()
        registerDefaults() //for that initial value for a fresh install
        handleFirstTime()
    }
    
    func documentsDirectory() -> String {
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
                
                //add this when we add sorting logic
                sortChecklists()
            }
        }
    }
    
    //func to set default values for fresh install of the app
    func registerDefaults(){
        //let dictionary = [ "ChecklistIndex": -1 ]
        //change to add firsttime
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true ]
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
        }
        set {
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            //NSUserDefaults.standardUserDefaults().synchronize() //testing bug - will crash - fixes in alllistsvc viewdidappear
        }
    }
    
    func handleFirstTime(){
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        if firstTime {
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sortInPlace({ checklist1, checklist2 in return
        checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending })
    }
    
    
}