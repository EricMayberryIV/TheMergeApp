//
//  ViewController.swift
//  TwitterApp
//
//  Created by Apple on 2/6/16.
//  Copyright © 2016 Apple. All rights reserved.
//

import UIKit
import Social
import Accounts
import Twitter



class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    
    
    
    
    
    

    @IBOutlet var tweetTableView: UITableView!

    
     var dataSource = [AnyObject]()
    

    
    /*    func facebookTimeline(){
    
    
        let acctStore = ACAccountStore()
        let acctType = acctStore.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierFacebook)
        
        let pstingOptions = [ACFacebookAppIdKey:
            "1718570695033272",
            ACFacebookPermissionsKey: ["josephjamir96@gmail.com"],
            ACFacebookAudienceKey: ACFacebookAudienceFriends]
        
        acctStore.requestAccessToAccountsWithType(acctType,
            options: pstingOptions as [NSObject : AnyObject]) {
                success, error in
                if success {
                    
                    let options = [ACFacebookAppIdKey:"<1718570695033272", ACFacebookPermissionsKey: ["publish_actions"], ACFacebookAudienceKey: ACFacebookAudienceFriends]
                    
                    acctStore.requestAccessToAccountsWithType(acctType,
                        options: options as [NSObject : AnyObject]) {
                            success, error in
                            if success {
                                var acctsArray =
                                acctStore.accountsWithAccountType(acctType)
                                
                                if acctsArray.count > 0 {
                                    let facebookAccount = acctsArray[0] as! ACAccount
                                    
                                    var param = Dictionary<String, AnyObject>()
                                    param["access_token"] =
                                        facebookAccount.credential.oauthToken
                                    param["message"] = "My first Facebook post from iOS 8"
                                    
                                     let feedURL = NSURL(string:
                                        "https://graph.facebook.com/me/feed")
                                    
                                    let pstRequest = SLRequest(forServiceType:
                                        SLServiceTypeFacebook, 
                                        requestMethod: SLRequestMethod.POST, 
                                        URL: feedURL, 
                                        parameters: param)
                                    pstRequest.performRequestWithHandler(
                                        {(responseData: NSData!, 
                                            urlResponse: NSHTTPURLResponse!, 
                                            error: NSError!) -> Void in
                                            print("Twitter HTTP response \(urlResponse.statusCode)")
                                    })
                                }
                            } else {
                                print("Access denied")
                                print(error.localizedDescription)
                            }
                    }
                } else {
                    print("Access denied")
                    print(error.localizedDescription)
                }
        }
    
    }
    */

            
        
    func getTimeLine() {
        
        let account = ACAccountStore()
        let accountType = account.accountTypeWithAccountTypeIdentifier(
            ACAccountTypeIdentifierTwitter)
        
        account.requestAccessToAccountsWithType(accountType, options: nil,
            completion: {(success: Bool, error: NSError!) -> Void in
                
                if success {
                    let arrayOfAccounts =
                    account.accountsWithAccountType(accountType)
                    
                    if arrayOfAccounts.count > 0 {
                        let twitterAccount = arrayOfAccounts.last as! ACAccount
                        
                       let requestURL = NSURL(string:
                        "https://api.twitter.com/1.1/statuses/home_timeline.json")

                        
                        //show.json?")
                        
                        
                        let parameters = ["screen_name" : "@JoJo_BigDreams",
                            "include_entities" : "0"
,                            "include_rts" : "0",
                            "trim_user" : "0",
                            "count" : "100"]
                        
                        let postRequest = SLRequest(forServiceType:
                            SLServiceTypeTwitter,
                            requestMethod: SLRequestMethod.GET,
                            URL: requestURL,
                            parameters: parameters)
                        
                        postRequest.account = twitterAccount
                        
                        postRequest.performRequestWithHandler(
                            {(responseData: NSData!,
                                urlResponse: NSHTTPURLResponse!,
                                error: NSError!) -> Void in
                                
                                do {
                                    self.dataSource = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableLeaves) as! [AnyObject]
                                } catch _ {
                                    
                                }
                                
                                if self.dataSource.count != 0 {
                                    dispatch_async(dispatch_get_main_queue()) {
                                        self.tweetTableView.reloadData()
                                    }
                                }
                        })
                    }
                } else {
                    print("Failed to access account")
                }
        })
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tweetTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tweetTableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);

        self.getTimeLine()
       //self.facebookTimeline()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tweetTableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetCell
        let row = indexPath.row
        let tweet = self.dataSource[row] as! NSDictionary
        let currentUser:NSDictionary = tweet.objectForKey("user") as! NSDictionary
        
        if let name = currentUser.objectForKey("name") as? String {
        
            cell.nameLabel!.text = name
            
        }
        let profilePicUrl = currentUser.objectForKey("profile_image_url") as! String
        let imageURL = NSURL( string: profilePicUrl)
        let imageData = NSData(contentsOfURL: imageURL!)
           cell.imageView?.image = UIImage(data: imageData!)
        cell.tweetLabel!.text = tweet.objectForKey("text") as? String
        
        
        cell.tweetLabel!.numberOfLines = 0
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

