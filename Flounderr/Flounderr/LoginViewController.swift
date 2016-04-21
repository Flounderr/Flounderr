//
//  LoginViewController.swift
//  Flounderr
//
//  Created by Ha Nuel Lee on 3/29/16.
//  Copyright © 2016 Flounderr. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var signUpView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var loginErrorLabel: UILabel!
    @IBOutlet weak var signUpErrorLabel: UILabel!
    
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
        scrollView.delegate = self
        
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
        PFUser.logInWithUsernameInBackground(loginUsernameTextField.text!, password: loginPasswordTextField.text!) { (user: PFUser?, error: NSError?) in
            if let user = user {
                print("\nInside LoginViewController: Yay! Login is successful\n")
                self.performSegueWithIdentifier("SyncGoogleSegue", sender: nil)
            }
            else {
                print("\nInside LoginViewController: Logging in failed!\n")
                let errorCode = error!.code
                switch errorCode {
                case 100:
                    self.loginErrorLabel.text = "Cannot connect to server. Please try again later."
                    break
                case 101:
                    self.loginErrorLabel.text = "The username or password is incorrect."
                    break
                case 200:
                    self.loginErrorLabel.text = "Please type in your username."
                    break
                case 201:
                    self.loginErrorLabel.text = "Please type in your password."
                    break
                default:
                    self.loginErrorLabel.text = "Something went wrong. Please try again later."
                    break
                }
                print(error!.localizedDescription)
            }
        }
    }
    @IBAction func onSignUp(sender: AnyObject) {
        if (signUpUsernameTextField.text ?? "").isEmpty {
            signUpErrorLabel.text = "Username is required."
        }
        else if (signUpPasswordTextField.text ?? "").isEmpty {
            signUpErrorLabel.text = "Password is required."
        }
        else if signUpPasswordTextField.text != signUpConfirmPasswordTextField.text {
            signUpErrorLabel.text = "The password doesn't match."
        }
        else {
            let newUser = PFUser()
            newUser.username = signUpUsernameTextField.text!
            newUser.password = signUpPasswordTextField.text!
            
            newUser.signUpInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                if success {
                    print("\nInside LoginViewController: Yay! Signing up was successful\n")
                    self.loginErrorLabel.text = ""
                    self.signUpErrorLabel.text = ""
                    self.performSegueWithIdentifier("SyncGoogleSegue", sender: nil)
                }
                else {
                    let errorCode = error!.code
                    switch errorCode {
                    case 100:
                        self.signUpErrorLabel.text = "Cannot connect to server. Please try again later."
                        break
                    case 202:
                        self.signUpErrorLabel.text = "The username is already taken."
                        break
                    default:
                        self.signUpErrorLabel.text = "Something went wrong. Please try again later."
                        break
                    }
                    print(error!.localizedDescription)
                }

            })

            
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
