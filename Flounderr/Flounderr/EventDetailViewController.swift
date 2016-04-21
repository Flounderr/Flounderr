//
//  EventDetailViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/31/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import WebKit

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
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
