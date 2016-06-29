//
//  AppDelegate.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/27/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        if(User.currentUser != nil) {
            //There is a current user, set the initial View Controller to be the NavigationViewController before the TweetsViewController
            print("There is a current user")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tweetsNavVC = storyboard.instantiateViewControllerWithIdentifier("TweetsNavigationController")
            window?.rootViewController = tweetsNavVC
        }
        
        //If anyone posts UserDidLogout then this code block runs
        NSNotificationCenter.defaultCenter().addObserverForName(User.userDidLogoutNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (NSNotification) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateInitialViewController()
            self.window?.rootViewController = loginVC
        }
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    /* Function: openURL
     * If the Authentification was made, we are redirected back to this app and this function will be called. 
     * In this function we again setup the Twitter client and then if fetchAccessTokenWithPath succeeds 
     * in getting us an accessToken then we can go ahead and access the API's endpoints. 
     * So, we use twitterclient.GET to get the JSON file data (see documentation online)
     */
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        
        //Setup the Twitter Client
        let twitterclient = TwitterClient.sharedInstance
    
        twitterclient.handleOpenUrl(url)
        
        return true
    }

    
    
    
    
}

