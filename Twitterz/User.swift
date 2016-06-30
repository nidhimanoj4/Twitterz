//
//  User.swift
//  
//
//  Created by Nidhi Manoj on 6/27/16.
//
//

import UIKit

class User: NSObject {
    static let userDidLogoutNotification = "UserDidLogout"

    //These are fields of User
    var name: NSString?
    var screenname: NSString?
    var descriptionTagline: NSString?
    var profileImageUrl: NSURL?
    var numTweets: Int = 0
    var numFollowing: Int = 0
    var numFollowers: Int = 0
    
    var dictionary: NSDictionary?
    
    init (dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String    //Attempt to cast as a String, otehrwise it is nil
        screenname = dictionary["screen_name"] as? String
        descriptionTagline = dictionary["description"] as? String
        numTweets = (dictionary["statuses_count"] as? Int) ?? 0
        numFollowing = (dictionary["friends_count"] as? Int) ?? 0
        numFollowers = (dictionary["followers_count"] as? Int) ?? 0
        
        let profile_image_url_string = dictionary["profile_image_url_https"] as? String
        if let profile_image_url_string = profile_image_url_string {
            profileImageUrl = NSURL(string: profile_image_url_string)
        }
    }
    
    static var _currentUser: User?
    //This is a computed property so when someone tries to access this property, the following code is executed
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                //Check if there is data in currentUser. If there is, turn it back into a user and save it as a current_user.
                let defaults = NSUserDefaults.standardUserDefaults()
                let userData = defaults.objectForKey("currentUserData") as? NSData
                
                if let userData = userData {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(userData, options: []) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
            
            return _currentUser
        }
        set (user) {
            _currentUser = user
            let defaults = NSUserDefaults.standardUserDefaults()
            if let user = user {
                //Turn the user back into the original JSON data
                let data = try! NSJSONSerialization.dataWithJSONObject(user.dictionary!, options: [])
                    defaults.setObject(data, forKey: "currentUserData")
            } else {
                defaults.setObject(nil, forKey: "currentUserData")
            }
            defaults.synchronize() //This is like saving the current settings
        }
    }
    
    
}
