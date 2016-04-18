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
    // The current user that's logged in
    static var currentUser: User?
    
    // Properties of a User
    var PFUserObject: PFUser?
    var userGoogleServce: Int? // Change later
    
    var authorizeSuccess: (() -> ())?
    var authorizeFailure: ((NSError) -> ())?

    /// Constructor for User class.
    ///
    /// - parameter PFUserObject: PFUser object of the User that will be stored in the Parse server.
    init(PFUserObject: PFUser) {
        self.PFUserObject = PFUserObject
    }
    
    /// Signs the User up for the app.
    ///
    /// - parameter username: Username of the User
    /// - parameter password: Password of the User
    func signUp(username: String?,
                password: String?,
                success: () -> (),
                failure: (NSError) -> ()) {
        
        authorizeSuccess = success
        authorizeFailure = failure
        
        // Create a new PFUser
        let newUser = PFUser()
        newUser.username = username
        newUser.password = password
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) in
            if success {
                // If sign up is successful, set the current user of the app
                User.currentUser = User(PFUserObject: newUser)
                self.authorizeSuccess!()
            }
            else {
                self.authorizeFailure!(error!)
            }
        }
    }
    
    /// Logs User into the app.
    ///
    /// - parameter username: Username of the User
    /// - parameter password: Password of the User
    func login(username: String?,
               password: String?,
               success: () -> (),
               failure: (NSError) -> ()) {
        
        authorizeSuccess = success
        authorizeFailure = failure
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user: PFUser?, error: NSError?) in
            if user != nil {
                // If login is successful, set the current user of the app
                User.currentUser = User(PFUserObject: user!)
                self.authorizeSuccess!()
            }
            else if error != nil {
                self.authorizeFailure!(error!)
            }
        }
    }
    
    /// Logs User through Google to access Google Calendar information.
    ///
    /// - parameter currView: The current view within the app where the Google authorization page should be shown
    /// - parameter segueName: Name of the segue that should be taken after the User has been successfully authorized
    /// - returns: GTMOAuth2ViewControllerTouch
    func loginThroughGoogleCalendar(currView: UIViewController, segueName: String?) -> GTMOAuth2ViewControllerTouch {
        return GoogleCalendarClient.sharedInstance.authorize(currView, segueName: segueName)
    }
    
    /// Logs User out of the app.
    func logout() {
        PFUser.logOut()
        // Dereference the current user on logout
        User.currentUser = nil
        GoogleCalendarClient.sharedInstance.deauthorize()
    }
    
    /// Fetches events in User's calendar. If the User authorized Google, it fetches events for both Google Calendar and the in-app Calendar app. If the User was not authorized for Google, it only fetches the in-app Calendar app events.
    func fetchEvents() {
        
    }
    
    /// Add an event to User's calendar. If the User authorized Google, it adds the event to both Google Calendar and the in-app Calendar app. If the User was not authorized for Google, it only adds the event to the in-app Calendar app.
    func addEvent() {
        
    }
    
    /// Checks if the User authorized Google.
    ///
    /// - returns: Bool
    func isUserGoogleAuthorized() -> Bool {
        return GoogleCalendarClient.sharedInstance.isUserAuthorized()
    }
    
}
