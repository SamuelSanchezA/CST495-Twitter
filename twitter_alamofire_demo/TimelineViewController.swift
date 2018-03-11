//
//  TimelineViewController.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ComposeViewControllerDelegate, TweetCellDelegate {
    
    func tweetCell(_ tweetCell: TweetCell, didTap user: User) {
        performSegue(withIdentifier: "profile", sender: user)
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    var tweets: [Tweet] = []
    var refreshControl: UIRefreshControl!
    @IBOutlet weak var tableView: UITableView!
    var isMoreDataLoading = false
    var loadingMoreView : InfiniteScrollActivityView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        profileImage.af_setImage(withURL: (User.current?.profile_url)!)
        profileImage.layer.cornerRadius = 15
        profileImage.clipsToBounds = true
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset
        insets.bottom += InfiniteScrollActivityView.defaultHeight
        tableView.contentInset = insets
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        getFeed()
    }
    
    @IBAction func composeTweet(_ sender: Any) {
        performSegue(withIdentifier: "tweet", sender: nil)
    }
    
    @IBAction func goToProfile(_ sender: Any) {
        print("Going to profile")
        performSegue(withIdentifier: "profile", sender: nil)
    }
    
    @IBAction func logout(_ sender: Any) {
        APIManager.shared.logout()
    }
    
    func did(post: Tweet) {
        // Do something
        getFeed()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if(!isMoreDataLoading){
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
        
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // ... Code to load more results ...
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()

                APIManager.tweetReturnLimit += 10
                getFeed()
            }
        }
    }
    
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        APIManager.tweetReturnLimit = 20
        getFeed()
    }
    
    func getFeed(){
        APIManager.shared.getHomeTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.isMoreDataLoading = false
                self.tweets = tweets
                self.tableView.reloadData()
            } else if let error = error {
                print("Error getting home timeline: " + error.localizedDescription)
            }
        }
        self.loadingMoreView?.stopAnimating()
        self.refreshControl.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destVC = segue.destination as? TweetDetailViewController{
            let senderCell = sender as! TweetCell
            let indexPath = tableView.indexPath(for: senderCell)
            destVC.tweet = tweets[(indexPath?.row)!]
        }
        
        else if let destVC = segue.destination as? ComposeViewController{
            destVC.delegate = self
        }
        
        else if let destVC = segue.destination as? ProfileViewController{
            // Came from tableview
            if(sender != nil){
                destVC.user = sender as! User
            }
            // Profile picker in nav menu
            else{
                destVC.user = User.current
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
