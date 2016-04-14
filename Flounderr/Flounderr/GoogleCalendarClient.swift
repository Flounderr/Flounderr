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
    
    private let scopes = [kGTLAuthScopeCalendar]

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
    func deauthorize() {
        service.authorizer = nil
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
    func addEvent() {
        var newEvent: GTLCalendarEvent = GTLCalendarEvent()
        newEvent.summary = "Event summary: You will do stuff except everything"
        newEvent.descriptionProperty = "Event description: This event shall be fun"
        
        print("\naddEvent() being called!!!\n")
        
        var startDateTime: GTLDateTime = GTLDateTime(date: NSDate(), timeZone: NSTimeZone(abbreviation: "EST"))
        var endDateTime: GTLDateTime = GTLDateTime(date: NSDate().dateByAddingTimeInterval(60 * 60), timeZone: NSTimeZone(abbreviation: "EST"))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        
        newEvent.start = GTLCalendarEventDateTime()
        newEvent.start.dateTime = startDateTime
        print("startDate = \(dateFormatter.stringFromDate(newEvent.start.dateTime.date))\n")
        
        newEvent.end = GTLCalendarEventDateTime()
        newEvent.end.dateTime = endDateTime
        print("endDate = \(dateFormatter.stringFromDate(newEvent.end.dateTime.date))\n")
        
        GTLQueryCalendar.queryForEventsInsertWithObject(newEvent, calendarId: "primary")
    }
    func isUserAuthorized() -> Bool {
        if service.authorizer == nil {
            return false
        }
        return service.authorizer.canAuthorize!
    }
}
