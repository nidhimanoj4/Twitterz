//
//  UserProfileViewController.swift
//  
//
//  Created by Nidhi Manoj on 6/30/16.
//
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var user: User!
    
    //This is the usertimeline of TweetCells
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var descriptionTagline: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numFollowersLabel: UILabel!
    
    var mytweets: [Tweet]! = []
    // Initialize a UIRefreshControl
    let refreshControl = UIRefreshControl()
    
    func setProfileInfo() {
        usernameLabel.text = "Username: \(user.name!) "
        let userProfileImageUrl = user.profileImageUrl
        dispatch_async(dispatch_get_main_queue()){
            self.photoView.setImageWithURL(userProfileImageUrl!)
        }
        descriptionTagline.text = user.descriptionTagline as? String
        numTweetsLabel.text = "\(user.numTweets) tweets"
        numFollowingLabel.text = "\(user.numFollowing) following"
        numFollowersLabel.text = "\(user.numFollowers) followers"
    }
    
    func refreshUserTableViewData() {
        let twitterclient = TwitterClient.sharedInstance
        //Load 20 tweets from the userTimeline
        twitterclient.userTimeline(user.screenname!, success: { (tweetsArray: [Tweet]) in
            self.mytweets = tweetsArray
            self.tableView.reloadData()
            // Tell the refreshControl to stop spinning
            self.refreshControl.endRefreshing()
            
        }) { (error: NSError) in
            print("Error: \(error.localizedDescription)")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setProfileInfo()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //We already instantiated a global UIRefreshControl at the top
        refreshControl.addTarget(self, action: #selector(refreshUserTableViewData), forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 388)
        
        refreshUserTableViewData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let mytweets = mytweets {
            return mytweets.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let usertweetCell = tableView.dequeueReusableCellWithIdentifier("userTweetCell", forIndexPath: indexPath) as! userTweetCell
        
        let tweet = mytweets[indexPath.row]
        
        usertweetCell.tweetWrapped = tweet
        //In the TweetCell, there is a didSet that will set all the cell's labels and images using the tweet that we have given to TweetCell
        
        return usertweetCell
    }

    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
