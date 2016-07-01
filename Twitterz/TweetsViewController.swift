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
import DGElasticPullToRefresh

class TweetsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addTaglineTextField: UITextField!
    var tweets: [Tweet]! = []
    var justOpenedDetailPostViewController = false
    // Initialize a UIRefreshControl - we no longer need this because we substituted the cocoapod refresh animation
    //let refreshControl = UIRefreshControl()
    
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
            // Tell the refreshControl to stop spinning - we no longer need this because we substituted the cocoapod refresh animation
            //self.refreshControl.endRefreshing()
        }) { (error: NSError) -> () in
            print("Error: \(error.localizedDescription)")
        }
    }
    
/*    deinit {
        tableView.dg_removePullToRefresh()
    }
 */
    override func viewDidAppear(animated: Bool) {
        if justOpenedDetailPostViewController {
            refreshTableViewData()
        }
        justOpenedDetailPostViewController = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
/*      //We no longer need this because we substituted the cocoapod refresh animation  
        //We already instantiated a global UIRefreshControl at the top
        refreshControl.addTarget(self, action: #selector(refreshTableViewData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
*/
        refreshTableViewData()
        
        /* Here is where cocoa pod pull to refresh animation code begins */
        // Initialize tableView
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 70/255.0, blue: 200/255.0, alpha: 0.1)
        tableView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            // Do not forget to call dg_stopLoading() at the end
            self?.tableView.dg_stopLoading()
            }, loadingView: loadingView)
        tableView.dg_setPullToRefreshFillColor(UIColor(red: 137/255.0, green: 204/255.0, blue: 255/255.0, alpha: 1.0))
        tableView.dg_setPullToRefreshBackgroundColor(tableView.backgroundColor!)
        /* Here is where the cocoa pod pull to refresh animation code ends. There is also a deinit function ontop */
        
    }
    
    
    
    @IBAction func onImageButtonClicked(sender: AnyObject) {
        performSegueWithIdentifier("userProfileSegue", sender: sender)
    }
    
    @IBAction func onLogoutButton(sender: AnyObject) {
        TwitterClient.sharedInstance.logout()
    }
    
    
    @IBAction func onAddTweetClicked(sender: AnyObject) {
        let originalString = addTaglineTextField.text! ?? ""
        var newTextForTweet = originalString.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        
        TwitterClient.sharedInstance.addTweet(newTextForTweet!, success: { 
            self.refreshTableViewData()

        }) { (error: NSError) in
        }
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
                tweet.favorited = true
                TwitterClient.incrementLikes(tweet, success: { (didIncrementWork: Bool) in
                    tweet.favoriteCount += 1
                    cell.favoritesCountLabel.text = String(tweet.favoriteCount)
                    likeButton.selected = true  //default is gray heart, selected is red heart
                    self.refreshTableViewData()
                }) { (error: NSError) in
                }
            } else {
                //Unlike the tweet
                tweet.favorited = false
                TwitterClient.decrementLikes(tweet, success: { (didIncrementWork: Bool) in
                    tweet.favoriteCount -= 1
                    cell.favoritesCountLabel.text = String(tweet.favoriteCount)
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
                cell.retweetCountLabel.text = String(tweet.retweetCount)
                retweetButton.selected = true  //default is gray icon, selected is green icon
                self.refreshTableViewData()
            }) { (error: NSError) in
            }
        } else {
            //Unlike the tweet
            TwitterClient.decrementRetweets(tweet, success: { (didIncrementWork: Bool) in
                tweet.retweetCount -= 1
                cell.retweetCountLabel.text = String(tweet.retweetCount)
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
        
        tweetCell.tweetWrapped = tweet
        //In the TweetCell, there is a didSet that will set all the cell's labels and images using the tweet that we have given to TweetCell
        
        return tweetCell
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "detailTweetSegue") {
            let cell = sender as! UITableViewCell
            let indexPath =  tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            let detailTweetViewController = segue.destinationViewController as! DetailTweetViewController
            detailTweetViewController.tweet = tweet
            justOpenedDetailPostViewController = true
        }
        if (segue.identifier == "userProfileSegue") {
            
            let buttonOnImage = sender as! UIButton
            let cell = (buttonOnImage.superview)!.superview as! TweetCell
            let indexPath =  tableView.indexPathForCell(cell)
            let tweet = tweets[indexPath!.row]
            
            let userProfileViewController = segue.destinationViewController as! UserProfileViewController
            userProfileViewController.user = tweet.userForTweet
        }


    }


}

extension UIScrollView {
    func dg_stopScrollingAnimation() {}
}