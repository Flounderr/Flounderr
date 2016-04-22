//
//  EventDetailViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/31/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import WebKit
import Parse

class EventDetailViewController: UIViewController {
    var recognizedText: String!
    let regexMonths = [
        ["month":1, "regex":try! NSRegularExpression(pattern: "Jan(uary)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":2, "regex":try! NSRegularExpression(pattern: "Feb(rurary)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":3, "regex":try! NSRegularExpression(pattern: "Mar(ch)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":4, "regex":try! NSRegularExpression(pattern: "Apr(il)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":5, "regex":try! NSRegularExpression(pattern: "May", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":6, "regex":try! NSRegularExpression(pattern: "Jun(e)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":7, "regex":try! NSRegularExpression(pattern: "Jul(y)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":8, "regex":try! NSRegularExpression(pattern: "Aug(ust)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":9, "regex":try! NSRegularExpression(pattern: "Sep(tember)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":10, "regex":try! NSRegularExpression(pattern: "Oct(tober)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":11, "regex":try! NSRegularExpression(pattern: "Nov(ember)?", options: NSRegularExpressionOptions.CaseInsensitive)],
        ["month":12, "regex":try! NSRegularExpression(pattern: "Dec(ember)?", options: NSRegularExpressionOptions.CaseInsensitive)]]
    
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    
    
    
    @IBOutlet weak var addEventButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print("Inside EventDetailViewController: \(recognizedText)")
        var month = 1
        for regexMonth in regexMonths {
            if (regexMonth["regex"] as! NSRegularExpression).firstMatchInString(recognizedText, options: [], range: NSMakeRange(0, recognizedText.characters.count)) != nil {
                month = regexMonth["month"] as! Int
                break
            }
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        var eventDay = "\(month)/1/2016"
        if let convertedDate = dateFormatter.dateFromString(eventDay) {
            dateDatePicker.date = convertedDate
        }
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        eventDay += " 00:00"
        if let convertedDate = dateFormatter.dateFromString(eventDay) {
            timeDatePicker.date = convertedDate
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onAddEvent(sender: AnyObject) {
        if (eventNameTextField.text ?? "").isEmpty {
            var alert = UIAlertController(title: "Error", message: "An event name is required!", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Ok", style: .Cancel) { (action) -> Void in
                
            }
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm"
        
        let calendar = NSCalendar.currentCalendar()
        
        let dateComponents = calendar.components([.Day , .Month , .Year], fromDate: dateDatePicker.date)
        let timeComponents = calendar.components([.Day , .Month , .Year, .Hour, .Minute], fromDate: timeDatePicker.date)
        
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        
        let eventDate = calendar.dateFromComponents(dateComponents)
        if GoogleCalendarClient.sharedInstance.isUserAuthorized() {
            GoogleCalendarClient.sharedInstance.addEvent(eventDate!, eventDescription: eventNameTextField.text!) { (success: Bool) in
                if success {
                    self.performSegueWithIdentifier("reloadCalendarSegue", sender: nil)
                }
                else {
                    print("Adding event failed...")
                }
            }
        }
        
        let event = "\(PFUser.currentUser()!.username!)@\(eventNameTextField.text!)@\(dateFormatter.stringFromDate(eventDate!))@\(locationTextField.text!)\n"
        
        //print(event)
        
        UserMedia.postUserPost(event, user: PFUser.currentUser()! ,completion: nil)
        self.performSegueWithIdentifier("reloadCalendarSegue", sender: nil)
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
