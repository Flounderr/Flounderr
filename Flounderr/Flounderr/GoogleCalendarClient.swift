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
            let query = GTLQueryCalendar.queryForEventsListWithCalendarId("primary")
            query.maxResults = 15
            query.timeMin = GTLDateTime(date: NSDate(), timeZone: NSTimeZone.localTimeZone())
            query.singleEvents = true
            query.orderBy = kGTLCalendarOrderByStartTime
            service.executeQuery(query, completionHandler: { (ticekt: GTLServiceTicket!, response: AnyObject!, error: NSError!) in
                var eventString = ""
                print("\n\nEVENTS!!!!!!!!!!!!!!!!!\n\n")
                // Print the event summaries...
                if error != nil {
                    print("Event fetching Error: ", error.localizedDescription)
                    return
                }
                if let events = response.items() where !events.isEmpty {
                    for event in events as! [GTLCalendarEvent] {
                        var start: GTLDateTime! = event.start.dateTime ?? event.start.date
                        var startString = NSDateFormatter.localizedStringFromDate(start.date, dateStyle: .ShortStyle, timeStyle: .ShortStyle)
                        eventString += "\(startString) - \(event.summary)\n"
                    }
                }
                else {
                    eventString = "No upcoming events found"
                }
                print(eventString)
            })
        }
        else {
            print("Can't fetch event because authorization wasn't successful.")
        }
    }
    func isUserAuthorized() -> Bool {
        if service.authorizer == nil {
            return false
        }
        return service.authorizer.canAuthorize!
    }
}
