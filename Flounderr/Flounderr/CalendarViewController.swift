//
//  CalendarViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/29/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import CVCalendar
import Parse
import EventKit

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var eventList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        menuView.delegate = self
        calendarView.delegate = self
        
        print("\nviewWillAppear() for CalendarViewController called!\n")
        
        let defaults = NSUserDefaults.standardUserDefaults()
        var eventList = NSMutableArray()
        defaults.setObject(eventList, forKey: "eventLists")
        
        loadInitialEventData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    func loadInitialEventData() {
        if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) == EKAuthorizationStatus.Authorized {
            
        }
        if GoogleCalendarClient.sharedInstance.isUserAuthorized() {
            GoogleCalendarClient.sharedInstance.fetchEvents({ (success: Bool) in
                if success {
                    for event in GoogleCalendarClient.sharedInstance.eventList {
                        let currEvent = event as! NSDictionary
                        let dictionary: NSMutableDictionary = ["date":currEvent["date"] as! NSDate,
                                            "description":currEvent["description"] as! String,
                                            "writtenToCalendar":false]
                        self.eventList.addObject(dictionary)
                    }
                }
                else {
                    print("Fetching events not successful!")
                }
                
                // Reload the calendar after fetching the events from GoogleCalendarClient
                self.reloadCalendar()
            })
        }
        else {
            print("User doesn't have a google account!")
        }

    }
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        /*
        if eventList.count > 0 && eventIndex < eventList.count && (dayView.date.day == CVDate(date: ((eventList.objectAtIndex(eventIndex) as! NSDictionary)["date"] as! NSDate)).day) {
            eventIndex += 1
            return true
        }
         */
        if eventList.count > 0 {
            for element in eventList {
                var currElement = element as! NSMutableDictionary
                if !(currElement["writtenToCalendar"] as! Bool) {
                    let potentialEventDate = CVDate(date: (currElement["date"] as! NSDate))
                    
                    //print("\n\(dayView.date.month) ?= \(potentialEventDate.month)\n")
                    //print("\(dayView.date.day) ?= \(potentialEventDate.day)\n")
                    //print("\(dayView.date.year) ?= \(potentialEventDate.year)\n")
                    
                    if dayView.date.month == potentialEventDate.month &&
                        dayView.date.day == potentialEventDate.day &&
                        dayView.date.year == potentialEventDate.year {
                        
                        print("writtenToCalendar modified!")
                        currElement.setValue(true, forKey: "writtenToCalendar")
                        return true
                    }
                    
                }
            }
        }
        return false
    }
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.blueColor()]
    }
    func didShowNextMonthView(date: NSDate) {
        reloadCalendar()
    }
    func didShowPreviousMonthView(date: NSDate) {
        reloadCalendar()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func reloadCalendar() {
        for element in eventList {
            var currElement = element as! NSMutableDictionary
            currElement.setValue(false, forKey: "writtenToCalendar")
        }
        if let cc = self.calendarView.contentController as? CVCalendarMonthContentViewController {
            cc.refreshPresentedMonth()
        }
        //print("reloadCalendar() called!")
    }
    @IBAction func onLogout(sender: AnyObject) {
        print("Logout called!")
        PFUser.logOut()
        GoogleCalendarClient.sharedInstance.deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName("UserDidLogout", object: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
