//
//  SyncGoogleCalendarViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/10/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse
import EventKit

class SyncGoogleCalendarViewController: UIViewController {
    //var googleClient: GoogleCalendarClient = GoogleCalendarClient()
    
    let eventStore = EKEventStore()
    
    @IBOutlet weak var syncGoogleCalendarButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            requestAccessToCalendar()
            break
        case EKAuthorizationStatus.Authorized:
            // Do nothing?
            break
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            print("We need permission!")
            break
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGoogleCalendarSync(sender: AnyObject) {
        // Ask permission to access eventkit
        presentViewController(GoogleCalendarClient.sharedInstance.authorize(self, segueName: "calendarSegue"), animated: true) { 
            print("Showing Google authentication page successful!")
            
        }
        //performSegueWithIdentifier("calendarSegue", sender: nil)
    }
    @IBAction func onSkip(sender: AnyObject) {
        // Ask permission to access eventkit
        performSegueWithIdentifier("calendarSegue", sender: nil)
    }
    func requestAccessToCalendar() {
        if EKEventStore.authorizationStatusForEntityType(EKEntityType.Event) != EKAuthorizationStatus.Authorized {
            eventStore.requestAccessToEntityType(EKEntityType.Event, completion: { (accessGranted: Bool, error: NSError?) in
                if accessGranted {
                    print("Calendar access granted!")
                }
                else {
                    print("Calendar access denied!")
                }
            })
        }
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
