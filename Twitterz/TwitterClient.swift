//
//  TwitterClient.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/27/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    static let sharedInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "7kygQDHFuBSq5aJaoyaempvX1", consumerSecret: "gsH9mjaUARlOeHj8HkgqU593PAcVjoZEPuMcoF4x5OkdCUh1DJ")
    
    var loginSuccess: ( ()->() )?
    var loginFailure: ( (NSError)->() )?
    
    
    func login(success: () -> (), failure: (NSError) -> ()) {
        loginSuccess = success
        loginFailure = failure
        
        
        //We need to authenticate that we are in fact the app creator who wants permission so get a request token (which sends user to the authorizing URL
        deauthorize() // This deauthorizes/logs out any previous sessions
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twitterzapp://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) in
            //I got the request token which is requestToken
            let authenticateURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")!
            //This function openURL of UIApplication opens up a URL in mobile Safari
            UIApplication.sharedApplication().openURL(authenticateURL)
            
        }) { (error: NSError!) in
            //We could not get the requestToken
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func handleOpenUrl(url: NSURL) {
        //The url contains the requestToken in it (try printing url.description)
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        
        //Use fetchAccessTokenWithPath to get the accessToken
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential!) in
            //I got the accessToken successfully
            
            self.currentAccount({ (user: User) -> () in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: NSError) -> () in
                self.loginFailure?(error)
            })
            
            
        }) { (error: NSError!) in
            print("Error: \(error.localizedDescription)")
            self.loginFailure?(error)
        }
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()) {
        //Use the GET function to get the information in the JSON files about my account
        GET("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task:NSURLSessionDataTask, response) in
            let userDictionary = response as! NSDictionary
            
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        })
    }
    
    
    func homeTimeline(success: ([Tweet]) -> (), failure: (NSError) -> ()) {
        //Use the GET function to get the information in the JSON files about the home timeline
        GET("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success:
            { (task: NSURLSessionDataTask, response: AnyObject?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
                
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) in
            failure(error)
            print("Error: \(error.localizedDescription)")
        })
    }
    
    
    class func incrementLikes(tweet: Tweet, success: (Bool) -> (), failure: (NSError) -> ()) {
        //Update the favorite_count variable in the data/network (Note: instructions provide a link for a POST function in the API)

        sharedInstance.POST("1.1/favorites/create.json?id=\(tweet.tweetID!)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //We successfully incremented the likes
            print("Success in adding a like")
            success(true)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    class func decrementLikes(tweet: Tweet, success: (Bool) -> (), failure: (NSError) -> ()) {
        sharedInstance.POST("1.1/favorites/destroy.json?id=\(tweet.tweetID!)", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //We successfully decremented the likes
            print("Success in destroying a like")
            success(true)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    class func incrementRetweets(tweet: Tweet, success: (Bool) -> (), failure: (NSError) -> ()) {
        //Update the retweet_count variable in the data/network (Note: instructions provide a link for a POST function in the API)
        
        sharedInstance.POST("1.1/statuses/retweet/\(tweet.tweetID!).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //We successfully incremented the retweets
            print("Success in adding a retweet")
            success(true)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }
    
    
    class func decrementRetweets(tweet: Tweet, success: (Bool) -> (), failure: (NSError) -> ()) {
        sharedInstance.POST("1.1/statuses/unretweet/\(tweet.tweetID!).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) in
            //We successfully decremented the retweets
            print("Success in destroying a retweet")
            success(true)
        }) { (task: NSURLSessionDataTask?, error: NSError) in
            print("Error: \(error.localizedDescription)")
            failure(error)
        }
    }

    
}
