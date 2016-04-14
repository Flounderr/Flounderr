//
//  User.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/13/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class User: NSObject {
    var PFUserObject: PFUser?
    var userGoogleServce: Int? // Change later
    
    static var authorizeSuccess: (() -> ())?
    static var authorizeFailure: ((NSError) -> ())?
    
    static let userDidLogoutNotification = "UserDidLogout"
    
    //static let userDidLogoutNotification = "UserDidLogout"
    
    static var currentUser: User?
    
    /*
    static var currentUser: User? {
        get {
            if _currentUser == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let PFUserObject = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! PFUser
                    _currentUser = User(PFUserObject: PFUserObject)
                }
            }
            return _currentUser
        }
        set(user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                let data = try! NSJSONSerialization.dataWithJSONObject(user.PFUserObject!, options: [])
                defaults.setObject(data, forKey: "currentUserData")
            }
            else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize()
        }
    }
    */
    
    /**
     Constructor for User class.
     */
    init(PFUserObject: PFUser) {
        self.PFUserObject = PFUserObject
    }
    /**
     #signUp
     
     Signs up new user.
    */
    static func signUp(username: String?, password: String?, success: () -> (), failure: (NSError) -> ()) {
        authorizeSuccess = success
        authorizeFailure = failure
        
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                currentUser = User(PFUserObject: newUser)
                self.authorizeSuccess!()
            }
            else {
                self.authorizeFailure!(error!)
            }
        }
    }
    /**
     # login
     
     Log user into the application.
     */
    static func login(username: String?, password: String?, success: () -> (), failure: (NSError) -> ()) {
        authorizeSuccess = success
        authorizeFailure = failure
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user: PFUser?, error: NSError?) in
            if user != nil {
                // Set the current user
                currentUser = User(PFUserObject: user!)
                self.authorizeSuccess!()
            }
            else if error != nil {
                self.authorizeFailure!(error!)
            }
        }
    }
    /**
     #loginGoogleCalendar
     
     Log user into Google Calendar.
    */
    static func loginThroughGoogleCalendar(currView: UIViewController, segueName: String?) -> GTMOAuth2ViewControllerTouch {
        return GoogleCalendarClient.sharedInstance.authorize(currView, segueName: segueName)
    }
    /**
     #logout
     
     Logs user out of the application.
     */
    static func logout() {
        PFUser.logOut()
        currentUser = nil
        GoogleCalendarClient.sharedInstance.deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }
    /**
     #fetchEvents
     
     If the user is authorized through Google, fetch both phone calendar events and Google Calendar events.
     If the user is not authorized through Google, ony fetch phone calendar events.
    */
    static func fetchEvents() {
        
    }
    /**
     #isUserGoogleAuthorized
     
     Checks if the user was authorized through Google.
    */
    static func isUserGoogleAuthorized() -> Bool {
        return GoogleCalendarClient.sharedInstance.isUserAuthorized()
    }
    
}
