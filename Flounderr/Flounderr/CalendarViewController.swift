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

class CalendarViewController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    var eventIndex: Int = 0
    var eventList = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuView.delegate = self
        calendarView.delegate = self
        
        loadInitialEventData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    func loadInitialEventData() {
        if GoogleCalendarClient.sharedInstance.isUserAuthorized() {
            GoogleCalendarClient.sharedInstance.fetchEvents({ (success: Bool) in
                if success {
                    for event in GoogleCalendarClient.sharedInstance.eventList {
                        self.eventList.addObject(event)
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
        
        
        if eventList.count > 0 && eventIndex < eventList.count && (dayView.date.day == CVDate(date: ((eventList.objectAtIndex(eventIndex) as! NSDictionary)["date"] as! NSDate)).day) {
            eventIndex++
            return true
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
        eventIndex = 0
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
