//
//  InboxViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/22/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var messages = [PFObject]?()
    
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        self.refreshControl.tintColor = UIColor .blueColor()
        tableView.addSubview(refreshControl)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UserMedia.fetchMessages(nil, completion: {(messages, error) -> () in
            //print("I'm here")
            self.messages = messages
            self.tableView.reloadData()
            //print(messages)
        })
        self.tableView.reloadData()
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if messages != nil {
            return messages!.count
        } else {
            return 0
        }
        
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MessageTableViewCell", forIndexPath: indexPath) as! MessageTableViewCell
        
        let message = messages![indexPath.row]
        
        cell.message = message
        
        
        print("cell should post")
        
        return cell
        
    }
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            
            dispatch_get_main_queue(), closure)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func onRefresh() {
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
        UserMedia.fetchMessages(nil, completion: {(messages, error) -> () in
            
            self.messages = messages
            
            self.tableView.reloadData()
        })
        
    }
    
    @IBAction func onDismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
