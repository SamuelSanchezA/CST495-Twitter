//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import DateToolsSwift
import AlamofireImage
import TTTAttributedLabel

protocol TweetCellDelegate: class {
    // TODO: Add required methods the delegate needs to implement
    func tweetCell(_ tweetCell: TweetCell, didTap user: User)
}

class TweetCell: UITableViewCell, TTTAttributedLabelDelegate {
    
    @IBOutlet weak var tweetTextLabel: TTTAttributedLabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteCountTextLabel: UILabel!
    @IBOutlet weak var retweetCountTextLabel: UILabel!
    
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.enabledTextCheckingTypes = NSTextCheckingResult.CheckingType.link.rawValue
            tweetTextLabel.delegate = self
            tweetTextLabel.text = tweet.text
            
            usernameLabel.text = tweet.user.name
            screennameLabel.text = "@\(tweet.user.screen_name)"
            
            dateLabel.text = "\(formattedDate(date: tweet.createdAtString))"
            
            favoriteCountTextLabel.text = "\(formattedCounter(count: tweet.favoriteCount!))"
            retweetCountTextLabel.text = "\(formattedCounter(count: tweet.retweetCount))"
            
            profileImageView.af_setImage(withURL: tweet.user.profile_url)
           
            if(tweet.favorited)!{
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
            }
            else{
                favoriteButton.setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            }
            if(tweet.retweeted){
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
            }
            else{
                retweetButton.setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
            }
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapUserProfile(_:)))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func didTapUserProfile(_ sender: UITapGestureRecognizer) {
        // TODO: Call method on delegate
        delegate?.tweetCell(self, didTap: tweet.user)
    }
    
    @IBAction func didTapFavorite(_ sender: Any) {
        // TODO: Update the local tweet model
        if(tweet.favorited == false){
            tweet.favorited = true
            tweet.favoriteCount! += 1
            favoriteCountTextLabel.text = "\(tweet.favoriteCount!)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "favor-icon-red"), for: .normal)
                    APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
                        if let  error = error {
                            print("Error favoriting tweet: \(error.localizedDescription)")
                        } else if let tweet = tweet {
                            print("Successfully favorited the following Tweet: \n\(tweet.text)")
                        }
                    }
        }
        else{
            tweet.favorited = false
            tweet.favoriteCount! -= 1
            favoriteCountTextLabel.text = "\(tweet.favoriteCount!)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "favor-icon"), for: .normal)
            APIManager.shared.unfavorite(tweet, completion: { (tweet, error) in
                if let  error = error {
                    print("Error unfavoriting tweet: \(error.localizedDescription)")
                } else if let tweet = tweet {
                    print("Successfully unfavorited the following Tweet: \n\(tweet.text)")
                }
            })
        }

    }
    
    func formattedCounter(count: Int) -> String{
        var formattedCount = ""
        // Billion, just in case
        if(count >= 1000000000){
            formattedCount = String(format: "%.1fB", Double(count) / 1000000000.0)
        }
        else if(count >= 1000000){
            formattedCount = String(format: "%.1fM", Double(count) / 1000000.0)
        }
        else if(count >= 10000){
            formattedCount = String(format: "%.1fK", Double(count) / 1000.0)
        }
        else{
            formattedCount = "\(count)"
        }
        
        return formattedCount
    }
    
    func formattedDate(date: String) -> String{
        
        let df = DateFormatter()
        df.dateStyle = .full
        df.timeStyle = .full

        var formattedTime = ""
        let today = Date()
        let postedDate = df.date(from: date)
        let timeDiff = postedDate?.secondsEarlier(than: today)
        
        //Seconds
        if(timeDiff! < 60){
            formattedTime = "\(timeDiff!)s"
        }
        //Minutes
        else if(timeDiff! < 3600){
            formattedTime = "\(timeDiff! / 60)m"
        }
        //Hours
        else if(timeDiff! < 86400){
            formattedTime = "\(timeDiff! / 60 / 60)h"
        }
        //Days
        else if(timeDiff! < 604800){
            formattedTime = "\(timeDiff! / 60 / 60 / 24)d"
        }
        //Simple date format
        else{
            let newDate = df.date(from: date)!
            df.dateStyle = .short
            df.timeStyle = .none
            formattedTime = df.string(from: newDate)
            //formattedTime = "Date"
        }
        return formattedTime
    }
    
    @IBAction func didTapRetweet(_ sender: Any) {
        if(tweet.retweeted == false){
            tweet.retweeted = true
            tweet.retweetCount += 1
            retweetCountTextLabel.text = "\(tweet.retweetCount)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "retweet-icon-green"), for: .normal)
                        APIManager.shared.retweet(tweet, completion: { (tweet, error) in
                            if let  error = error {
                                print("Error retweeting tweet: \(error.localizedDescription)")
                            } else if let tweet = tweet {
                                print("Successfully retweeting the following Tweet: \n\(tweet.text)")
                            }
                        })
        }
        else{
            tweet.retweeted = false
            tweet.retweetCount -= 1
            retweetCountTextLabel.text = "\(tweet.retweetCount)"
            (sender as! UIButton).setImage(#imageLiteral(resourceName: "retweet-icon"), for: .normal)
                        APIManager.shared.unretweet(tweet, completion: { (tweet, error) in
                            if let  error = error {
                                print("Error unretweeting tweet: \(error.localizedDescription)")
                            } else if let tweet = tweet {
                                print("Successfully unretweeted the following Tweet: \n\(tweet.text)")
                            }
                        })
        }
        
    }
}
