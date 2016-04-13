//
//  User.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/13/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit

class User: NSObject {
    var username: String?
    var googleUsername: String?
    var eventsArray: [GTLCalendarEvent]?
    
    static var _currentUser: User?
    static let userDidLogoutNotification = "UserDidLogout"
    
    init(eventsArray: [GTLCalendarEvent]) {
        // Do initialzation
    }
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let eventsArray = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! [GTLCalendarEvent]
                    _currentUser = User(eventsArray: eventsArray)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.eventsArray!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
}
