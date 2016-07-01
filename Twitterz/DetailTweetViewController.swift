//
//  DetailTweetViewController.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/29/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//

import UIKit

class DetailTweetViewController: UIViewController {

    var tweet: Tweet!
    
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let user = tweet.userForTweet
        userLabel.text = user!.name as? String
        
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
/*       dispatch_async(dispatch_get_main_queue()){
         cell.handleLikeButtonClicked()
         //TweetCell has an instance function that will, (depending on if the tweet is currently favorited or not) call incrementLikes/decrementLikes, update the favoriteCount, change the cell's favoriteCountLabel.text, and update the likeButton's image
         //Afterwards, update the tableView to reflect changes in the likes
         
         self.refreshTableViewData()
         }
*/
        
        //Increment/Decrement the tweet's favoriteCount variable
        if tweet.favorited == false {
            //Like the tweet
            tweet.favorited = true
            TwitterClient.incrementLikes(tweet, success: { (didIncrementWork: Bool) in
                self.tweet.favoriteCount += 1
                self.favoritesCountLabel.text = String(self.tweet.favoriteCount) + " favorites"
                self.likeButton.selected = true  //default is gray heart, selected is red heart
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            tweet.favorited = false
            TwitterClient.decrementLikes(tweet, success: { (didIncrementWork: Bool) in
                self.tweet.favoriteCount -= 1
                self.favoritesCountLabel.text = String(self.tweet.favoriteCount) + " favorites"
                self.likeButton.selected = false
            }) { (error: NSError) in
            }
        }
        
    }

    @IBAction func onRetweetButton(sender: AnyObject) {
        //Increment/Decrement the tweet's favoriteCount variable
        if tweet.retweeted == false {
            //Like the tweet
            TwitterClient.incrementRetweets(tweet, success: { (didIncrementWork: Bool) in
                self.tweet.retweetCount += 1
                self.retweetCountLabel.text = String(self.tweet.retweetCount) + " retweets"
                self.retweetButton.selected = true  //default is gray icon, selected is green icon
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            TwitterClient.decrementRetweets(tweet, success: { (didIncrementWork: Bool) in
                self.tweet.retweetCount -= 1
                self.retweetCountLabel.text = String(self.tweet.retweetCount) + " retweets"
                self.retweetButton.selected = false
            }) { (error: NSError) in
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
