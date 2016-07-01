//
//  LoginViewController.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/27/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.clipsToBounds = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    
    
    @IBAction func onLoginButtonClicked(sender: AnyObject) {
        //Create a Twitter Client
        let twitterclient = TwitterClient.sharedInstance
        
        twitterclient.login({  () -> () in
            //Login was a success
            print("I've logged in")
            self.performSegueWithIdentifier("loginSegue", sender: nil)
        }) { (error: NSError) -> () in
            //Login was not a success, I already print an error message, print again
            print("Error: \(error.localizedDescription)")
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
