//
//  EventDetailViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/31/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit

class EventDetailViewController: UIViewController {
    var recognizedText:String!
    @IBOutlet weak var recognizedTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Inside EventDetailViewController: \(recognizedText)")
        recognizedTextLabel.text = recognizedText
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
