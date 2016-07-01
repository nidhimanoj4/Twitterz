//
//  TweetCell.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/28/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    
    var tweetWrapped: Tweet? {
        didSet {
            let tweet = tweetWrapped!
            let user = tweet.userForTweet
            
            let usernameAsString = String(user!.name!) ?? ""
            userLabel.text = usernameAsString
            
            let userProfileImageUrl = user!.profileImageUrl
            dispatch_async(dispatch_get_main_queue()){
                self.photoView.setImageWithURL(userProfileImageUrl!)
            }
            
            taglineLabel.text = tweet.text as? String
            retweetCountLabel.text = String(tweet.retweetCount)
            favoritesCountLabel.text = String(tweet.favoriteCount)
            timestampLabel.text = String(tweet.relativeTime!)
            
            if tweet.favorited == false {
                likeButton.selected = false //If not liked, then present a gray heart
            } else {
                likeButton.selected = true //If liked, then present a red heart
            }
            
            if tweet.retweeted == false {
                retweetButton.selected = false //If not liked, then present a gray retweet icon
            } else {
                retweetButton.selected = true //If liked, then present a green retweet icon
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
    
    
/* //For refactoring purposes
     func handleLikeButtonClicked() {
        //Get the tweet
        let tweet = tweetWrapped!
        
        //Increment/Decrement the tweet's favoriteCount variable
        if tweet.favorited == false {
            //Like the tweet
            tweet.favorited = true
            TwitterClient.incrementLikes(tweet, success: { (didIncrementWork: Bool) in
                tweet.favoriteCount += 1
                self.favoritesCountLabel.text = String(tweet.favoriteCount) + " favorites"
                self.likeButton.selected = true  //default is gray heart, selected is red heart
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            tweet.favorited = false
            TwitterClient.decrementLikes(tweet, success: { (didIncrementWork: Bool) in
                tweet.favoriteCount -= 1
                self.favoritesCountLabel.text = String(tweet.favoriteCount) + " favorites"
                self.likeButton.selected = false
            }) { (error: NSError) in
            }
        }
        
    }
 */
    
}
