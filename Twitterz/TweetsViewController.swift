//
//  TweetsViewController.swift
//  Twitterz
//
//  Created by Nidhi Manoj on 6/28/16.
//  Copyright © 2016 Nidhi Manoj. All rights reserved.
//


/* //GET THE homeTimeline tweets
 twitterclient.homeTimeline({ (tweetsArray: [Tweet]) -> () in
 self.tweets = tweetsArray
 self.tableView.reloadData()
 }) { (error: NSError) -> () in
 print("Error: \(error.localizedDescription)")
 }
*/

import UIKit

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]!
    
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    
    /* Function: refreshTableViewData
     * Updates the tableView with the new data
     * Hides the RefreshControl
     */
    func refreshTableViewData() {
        let twitterclient = TwitterClient.sharedInstance
        //Load 20 tweets from the homeTimeline
        twitterclient.homeTimeline({ (tweetsArray: [Tweet]) -> () in
            self.tweets = tweetsArray
            self.tableView.reloadData()
            // Tell the refreshControl to stop spinning
            self.refreshControl.endRefreshing()
        }) { (error: NSError) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        //We already instantiated a global UIRefreshControl at the top
        refreshControl.addTarget(self, action: #selector(refreshTableViewData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        refreshTableViewData()
    }
    
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    @IBAction func onLikeButton(sender: AnyObject) {
        //Get that tweet by using sender = button -> super = contentView -> super = TweetCell
        let likeButton = sender as! UIButton
        let cell = (likeButton.superview)!.superview as! TweetCell
        
        //Get indexPath from cell by saying tableView.indexPathFromCell(cell)
        let indexPath = tableView.indexPathForCell(cell)
        //Get the tweet by saying tweets[indexPath.row]
        let tweet = tweets[indexPath!.row]
        
        //Increment/Decrement the tweet's favoriteCount variable
        if tweet.favorited == false {
            //Like the tweet
            TwitterClient.incrementLikes(tweet, success: { (didIncrementWork: Bool) in
                tweet.favoriteCount += 1
                cell.favoritesCountLabel.text = String(tweet.favoriteCount) + " favorites"
                likeButton.selected = true  //default is gray heart, selected is red heart
                self.refreshTableViewData()
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            TwitterClient.decrementLikes(tweet, success: { (didIncrementWork: Bool) in
                tweet.favoriteCount -= 1
                cell.favoritesCountLabel.text = String(tweet.favoriteCount) + " favorites"
                likeButton.selected = false
                self.refreshTableViewData()
            }) { (error: NSError) in
            }
        }
    }
    
    
    @IBAction func onRetweetButton(sender: AnyObject) {
        //Get that tweet by using sender = button -> super = contentView -> super = TweetCell
        let retweetButton = sender as! UIButton
        let cell = (retweetButton.superview)!.superview as! TweetCell
        
        //Get indexPath from cell by saying tableView.indexPathFromCell(cell)
        let indexPath = tableView.indexPathForCell(cell)
        //Get the tweet by saying tweets[indexPath.row]
        let tweet = tweets[indexPath!.row]
        
        //Increment/Decrement the tweet's favoriteCount variable
        if tweet.retweeted == false {
            //Like the tweet
            TwitterClient.incrementRetweets(tweet, success: { (didIncrementWork: Bool) in
                tweet.retweetCount += 1
                cell.retweetCountLabel.text = String(tweet.retweetCount) + " retweets"
                retweetButton.selected = true  //default is gray icon, selected is green icon
                self.refreshTableViewData()
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            TwitterClient.decrementRetweets(tweet, success: { (didIncrementWork: Bool) in
                tweet.retweetCount -= 1
                cell.retweetCountLabel.text = String(tweet.retweetCount) + " retweets"
                retweetButton.selected = false
                self.refreshTableViewData()
            }) { (error: NSError) in
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tweetCell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        let tweet = tweets[indexPath.row]
        
        let user = tweet.userForTweet
        tweetCell.userLabel.text = user!.name as? String
        
        let userProfileImageUrl = user!.profileImageUrl
        dispatch_async(dispatch_get_main_queue()){
            tweetCell.photoView.setImageWithURL(userProfileImageUrl!)
        }

        
        tweetCell.taglineLabel.text = tweet.text as? String
        tweetCell.retweetCountLabel.text = String(tweet.retweetCount) + " retweets"
        tweetCell.favoritesCountLabel.text = String(tweet.favoriteCount) + " favorites"
        tweetCell.timestampLabel.text = String(tweet.relativeTime!)

        if tweet.favorited == false {
            tweetCell.likeButton.selected = false //If not liked, then present a gray heart
        } else {
            tweetCell.likeButton.selected = true //If liked, then present a red heart
        }
        
        if tweet.retweeted == false {
            tweetCell.retweetButton.selected = false //If not liked, then present a gray retweet icon
        } else {
            tweetCell.retweetButton.selected = true //If liked, then present a green retweet icon
        }
        
        return tweetCell
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