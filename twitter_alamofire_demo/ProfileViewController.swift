//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Samuel on 3/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var user : User!{
        didSet{
            print("User: \(user.screen_name)")
        }
    }
    
    var tweets : [Tweet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        getFeed()
    }
    
    func getFeed(){
        APIManager.shared.getUserTimeLine(user_id: user.id) { (tweets, error) in
            if let tweets = tweets {
                //self.isMoreDataLoading = false
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
//            self.loadingMoreView?.stopAnimating()
//            self.refreshControl.endRefreshing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
            cell.user = user
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
            cell.tweet = tweets[indexPath.row - 1]
            cell.delegate = self
            return cell
        }
    }
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
         //performSegue(withIdentifier: "profile", sender: user)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destVC = segue.destination as? TweetDetailViewController{
            let senderCell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: senderCell)
            destVC.tweet = tweets[(indexPath?.row)! - 1]
        }
    }

}
