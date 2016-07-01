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

    var movingCircle: UIView!
    var movingCircleOriginalCenter: CGPoint!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = loginButton.frame.size.height / 2
        loginButton.clipsToBounds = true
        
    }
    @IBAction func didPanCircle(sender: UIPanGestureRecognizer) {
        let translation = sender.translationInView(view)
        if (sender.state == .Began) {
            var circleView = sender.view!
            movingCircle = circleView
            
            //Create a Pan Gesture Recognizer that calls onCustomPan and allows you to continue to pan the face
            let gestureRecognizerForFace = UIPanGestureRecognizer(target: self, action: "onCustomPan:")
            movingCircle.addGestureRecognizer(gestureRecognizerForFace)
            
            //Create a Tap Gesture Recognizer that allows you to delete the face on 2 taps
            let tapgestureRecognizerForFace = UITapGestureRecognizer(target: self, action: "onCustomDelete:")
            tapgestureRecognizerForFace.numberOfTapsRequired = 2
            movingCircle.addGestureRecognizer(tapgestureRecognizerForFace)
            
            
            movingCircle.userInteractionEnabled = true
            movingCircle.center = circleView.center
            
            
            movingCircleOriginalCenter = movingCircle.center
            
            UIView.animateWithDuration(0.3, animations: {
                self.movingCircle.transform = CGAffineTransformScale(self.movingCircle.transform, 9/8,9/8)
            })
        } else if (sender.state == .Changed) {
            movingCircle.center = CGPoint(x: movingCircleOriginalCenter.x + translation.x, y: movingCircleOriginalCenter.y + translation.y)
        } else if (sender.state == .Ended) {
            UIView.animateWithDuration(0.3, animations: {
                self.movingCircle.transform = CGAffineTransformScale(self.movingCircle.transform, 8/9,8/9)
            })
        }
    }
    
    func onCustomPan(sender: UIPanGestureRecognizer){
        let translation = sender.translationInView(view)
        if (sender.state == .Began){
            movingCircle = sender.view!
            movingCircleOriginalCenter = movingCircle.center
            UIView.animateWithDuration(0.3, animations: {
                self.movingCircle.transform = CGAffineTransformScale(self.movingCircle.transform, 9/8,9/8)
            })
        }else if (sender.state == .Changed){
            movingCircle.center = CGPoint(x: movingCircleOriginalCenter.x + translation.x, y: movingCircleOriginalCenter.y + translation.y)
        }else if (sender.state == .Ended){
            UIView.animateWithDuration(0.3, animations: {
                self.movingCircle.transform = CGAffineTransformScale(self.movingCircle.transform, 8/9,8/9)
            })
        }
    }
    
    func onCustomDelete(sender: UITapGestureRecognizer){
        let movingCircle = sender.view!
        movingCircle.removeFromSuperview()
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
