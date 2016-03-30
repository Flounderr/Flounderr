//
//  LoginViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/29/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var loginUsernameTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var signUpUsernameTextField: UITextField!
    @IBOutlet weak var signUpPasswordTextField: UITextField!
    @IBOutlet weak var signUpConfirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let pageWidth = scrollView.bounds.width
        let pageHeight = scrollView.bounds.height
        
        scrollView.contentSize = CGSizeMake(2 * pageWidth, pageHeight)
        scrollView.pagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.addSubview(loginView)
        scrollView.addSubview(signUpView)
        
        pageControl.numberOfPages = 2
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func changePage(sender: AnyObject) {
        let xOffset = scrollView.bounds.width * CGFloat(pageControl.currentPage)
        scrollView.setContentOffset(CGPointMake(xOffset, 0), animated: true)
    }
    
    @IBAction func onLogin(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(loginUsernameTextField.text!, password: loginPasswordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("Yay! successful logging in!")
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            }
            else {
                print(error?.localizedDescription )
            }
        }
    }
    @IBAction func onSignUp(sender: AnyObject) {
        
        let newUser = PFUser()
        newUser.username = signUpUsernameTextField.text
        if signUpPasswordTextField.text != signUpConfirmPasswordTextField.text {
            print("Password doesn't match!")
            
        }
        else {
            newUser.password = signUpPasswordTextField.text
            newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
                if success {
                    print("Yay! user was created.")
                    self.performSegueWithIdentifier("loginSegue", sender: nil)
                }
                else {
                    print(error?.localizedDescription)
                }
            }
        }
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
