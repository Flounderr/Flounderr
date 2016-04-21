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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        menuView.delegate = self
        calendarView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool {
        return true
        /*
        if GoogleCalendarClient.sharedInstance.isUserAuthorized() {
            GoogleCalendarClient.sharedInstance.fetchEvents({ (success: Bool) in
                if success {
                    //let dateFormatter = NSDateFormatter()
                    //dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
                    if GoogleCalendarClient.sharedInstance.eventList.count > 0 &&
                        GoogleCalendarClient.sharedInstance.eventList.count > self.eventIndex {
                        let event = GoogleCalendarClient.sharedInstance.eventList.objectAtIndex(self.eventIndex) as! NSDictionary
                        if dayView.date.day == CVDate(date: event["date"] as! NSDate).day {
                            print("\nDates match!!: ")
                        }
                        self.eventIndex++
                    }
                }
                else {
                    print("Fetching events not successful!")
                }
            })
        }
        else {
            print("User doesn't have a google account!")
        }
        */
    }
    func dotMarker(colorOnDayView dayView: DayView) -> [UIColor] {
        return [UIColor.blueColor()]
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
