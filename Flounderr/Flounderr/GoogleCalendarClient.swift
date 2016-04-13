//
//  GoogleCalendarClient.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/10/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit

class GoogleCalendarClient: NSObject {
    static let sharedInstance = GoogleCalendarClient()
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "46353301666-j784j95552qeq563v21b0hb674i725mb.apps.googleusercontent.com"
    
    private let scopes = [kGTLAuthScopeCalendarReadonly]
    private let service = GTLServiceCalendar()
    
    func authorize(currView: UIViewController, segueName: String?) -> GTMOAuth2ViewControllerTouch {
        // Initialize the Google Calendar API service
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(kKeychainItemName, clientID: kClientID, clientSecret: nil) {
            service.authorizer = auth
        }
        // Present the Google sign in view
        let scopeString = scopes.joinWithSeparator(" ")
        /*
        return GTMOAuth2ViewControllerTouch(scope: scopeString,
                                     clientID: kClientID,
                                     clientSecret: nil,
                                     keychainItemName: kKeychainItemName,
                                     delegate: self,
                                     finishedSelector: "setAuthorizer:finishedWithAuth:error:")
        */
        return GTMOAuth2ViewControllerTouch(scope: scopeString, clientID: kClientID, clientSecret: nil, keychainItemName: kKeychainItemName, completionHandler: { (controller: GTMOAuth2ViewControllerTouch!, authResult: GTMOAuth2Authentication!, error: NSError!) in
            // If there's an error authorizing user, return without doing anything
            if error != nil {
                self.service.authorizer = nil
                print("Authentication Error: ", error.localizedDescription)
                return
            }
            // Authorize the user
            self.service.authorizer = authResult
            print("Authorization successful!")
            // If the segue identifier was provided,
            // first dismiss the Google authorization page, then segue
            if segueName != nil {
                currView.dismissViewControllerAnimated(true, completion: nil)
                currView.performSegueWithIdentifier(segueName!, sender: nil)
            }
            else {
                // If the segue identifer was not provided,
                // just dismiss the Google authorization page
                currView.dismissViewControllerAnimated(true, completion: nil)
            }
        })
    }
    func fetchEvents() {
        // Only fetch event if the user was successfully authorized
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
            print("Can fetch event!")
        }
        else {
            print("Can't fetch event because authorization wasn't successful.")
        }
    }
    /*
    func setAuthorizer(currView: UIViewController, finishedWithAuth authResult: GTMOAuth2Authentication, error: NSError?) {
        if let error = error {
            service.authorizer = nil
            print("Authentiction Error: ", error.localizedDescription)
            return
        }
        service.authorizer = authResult
        print("Authorization successful!")
        currView.dismissViewControllerAnimated(true, completion: nil)
    }
    */
    
}
