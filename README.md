# Project 4 - Twitterz

Twitterz is a basic twitter app to read and compose tweets via the [Twitter API](https://apps.twitter.com/).

Time spent: 40 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign in using OAuth login flow
- [x] The current signed in user will be persisted across restarts
- [x] User can view last 20 tweets from their home timeline
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.
- [x] User can pull to refresh.
- [x] User should display the relative timestamp for each tweet "8m", "7h"
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap the profile image in any tweet to see another user's profile
   - [x] Contains the user header view: picture and tagline
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers
   - [x] Profile view should include that user's timeline
- [x] User can navigate to view their own profile
   - [x] Contains the user header view: picture and tagline
   - [x] Contains a section with the users basic stats: # tweets, # following, # followers

The following **optional** features are implemented:

- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count.
- [ ] When composing, you should have a countdown in the upper right for the tweet limit.
- [x] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [ ] User can reply to any tweet, and replies should be prefixed with the username and the reply_id should be set when posting the tweet
- [ ] Links in tweets are clickable
- [x] User can switch between timeline, mentions, or profile view through a tab bar
- [ ] Pulling down the profile page should blur and resize the header image.

The following **additional** features are implemented:

- [x] Added a cool bubble animation for pull-to-refresh in the Feed View
- [x] Animated the login screen so that user can interact by moving the circle via gestures and can delete it by tapping twice
- [x] Profile view includes the particular user's timeline
- [x] Added a banner of the user's background photo to the profile pages in the app
- [x] UI touch-ups include a launch screen and app icon among others


Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):
1. How to integrate Force touch for the tweets in the Feed View
2. Adding more animations via cocoapods

## Video Walkthrough

Here's a walkthrough of implemented user stories (see link below):
http://i.imgur.com/Uxr0qPA.gifv

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

Implementing the retweeting/liking features and getting accustomed to the GET and POST functions in the Twitter API were somewhat difficult. Also, keeping track of the segues in the many pages was important, especially when passing data to various TableViews (home timeline and various user timelines). It took a while to understand how to manage the various constraints in Auto layout, but screen rotation made it worth the time and effort! The animations in the feed view and the login screen were the most exciting features in this project. 

## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.
- [AFNetworking] (https://github.com/AFNetworking/AFNetworking) - networking task library
- [BDBOAuth1Manager] (https://github.com/bdbergeron/BDBOAuth1Manager) - supporting functionality for OAuth login flow
- [PrettyTimestamp] (https://github.com/jonhocking/PrettyTimestamp) - formatting for relative time stamp
- [SwiftyJSON] (https://github.com/SwiftyJSON/SwiftyJSON) - recommended for th
- [DGElasticPullToRefresh] (https://github.com/gontovnik/DGElasticPullToRefresh) - animations used for the pull to refresh in the Feed view


## License

    Copyright 2016 Nidhi Manoj

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
