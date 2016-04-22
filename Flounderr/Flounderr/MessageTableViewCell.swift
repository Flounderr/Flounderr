//
//  MessageTableViewCell.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 4/22/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class MessageTableViewCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    
    var message: PFObject? {
        
        didSet {
            
            let postedMessage = message!["request"] as? String
            if postedMessage != nil {
                messageLabel.text = postedMessage
                messageLabel.sizeToFit()
                
                let sender = message!["user"] as? String
                if sender != nil
                {
                    //print(sender)
                }
                
            }
            
        }
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
