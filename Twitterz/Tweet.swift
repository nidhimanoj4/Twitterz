//
//  Tweet.swift
//  
//
//  Created by Nidhi Manoj on 6/27/16.
//
//

import UIKit
import PrettyTimestamp

class Tweet: NSObject {

    var text: NSString?
    var timeStamp: NSDate?
    var relativeTime: NSString?
    var retweetCount: Int = 0
    var retweeted: Bool = false
    var favoriteCount: Int = 0
    var favorited: Bool = false
    var userForTweet: User?
    var tweetDictionary: NSDictionary?
    var tweetID: Int?
    
    init(dictionary: NSDictionary) {
        tweetDictionary = dictionary
        tweetID = dictionary["id"] as? Int
        text = dictionary["text"] as? String    //Attempt to cast as a String, otherwise it is nil
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        retweeted = (dictionary["retweeted"] as? Bool) ?? false
        favoriteCount = (dictionary["favorite_count"] as? Int) ?? 0
        favorited = (dictionary["favorited"] as? Bool) ?? false
        
        let userdictionary = dictionary["user"] as? NSDictionary
        userForTweet = User(dictionary: userdictionary!)

        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)

            relativeTime = timeStamp!.prettyTimestampSinceNow()
        }
    }
    
    //We get an array of tweets back from the server, so we want to parse it easily
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()   //This is now a Swift file that is mutable as oppposed to an NSArray []
        
        for dictionary in dictionaries {
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        return tweets
    }
    

}