//
//  SyncGoogleCalendarViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/10/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit

class SyncGoogleCalendarViewController: UIViewController {
    //var googleClient: GoogleCalendarClient = GoogleCalendarClient()
    
    @IBOutlet weak var syncGoogleCalendarButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGoogleCalendarSync(sender: AnyObject) {
        /*
        if User.currentUser!.isUserGoogleAuthorized() {
            presentViewController(User.currentUser!.loginThroughGoogleCalendar(self, segueName: "calendarSegue"), animated: true, completion: nil)
        }
        else {
            performSegueWithIdentifier("calendarSegue", sender: nil)
        }
        */
    }
    @IBAction func onSkip(sender: AnyObject) {
        performSegueWithIdentifier("calendarSegue", sender: nil)
    }
    
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
