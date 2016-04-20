//
//  User.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/13/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class User: NSObject, NSCoding {
    // The current user that's logged in
    static var _currentUser: User?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    // Properties of a User
    var PFUserObject: PFUser!
    var userGoogleServce: Int! // Change later

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let decodedData = defaults.objectForKey("currentUser") as? NSData
                
                if let decodedData = decodedData {
                    let decodedUser = NSKeyedUnarchiver.unarchiveObjectWithData(decodedData) as! User
                    _currentUser = decodedUser
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            
            if let user = user {
                let encodedData = NSKeyedArchiver.archivedDataWithRootObject(user)
                defaults.setObject(encodedData, forKey: "currentUser")
            }
            else {
                defaults.setObject(nil, forKey: "currentUser")
            }
            defaults.synchronize()
            print("Completed!")
        }
    }

    init(PFUserObject: PFUser?) {
        self.PFUserObject = PFUserObject
    }
    required init?(coder aDecoder: NSCoder) {
        self.PFUserObject = aDecoder.decodeObjectForKey("PFUserObject") as! PFUser
        //self.init(PFUserObject: obj)
    }
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(PFUserObject, forKey: "PFUserObject")
    }
    
}
