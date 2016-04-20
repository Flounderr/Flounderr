//
//  ParseUserClient.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/18/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class ParseUserClient: NSObject {
    static var sharedInstance: ParseUserClient = ParseUserClient()
    
    var authorizeSuccess: (() -> ())?
    var authorizeFailure: ((NSError) -> ())?

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
    
    func login(username: String?,
               password: String?,
               success: () -> (),
               failure: (NSError) -> ()) {
        
        authorizeSuccess = success
        authorizeFailure = failure
        
        PFUser.logInWithUsernameInBackground(username!, password: password!) { (user: PFUser?, error: NSError?) in
            if let user = user {
                User.currentUser = User(PFUserObject: user) // Fails
                self.authorizeSuccess!()
            }
            else {
                print("User log in error!")
                self.authorizeFailure!(error!)
            }
        }
    }
    
    func logout() {
        PFUser.logOut()
        // Dereference the current user on logout
        User.currentUser = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    
}
