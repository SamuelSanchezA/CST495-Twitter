//
//  DetailTweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Samuel on 3/1/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class DetailTweetCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            tweetLabel.text = tweet.text
            profileImageView.layer.cornerRadius = 25
            profileImageView.clipsToBounds = true
            profileImageView.af_setImage(withURL: tweet.user.profile_url)
            usernameLabel.text = tweet.user.name
            screennameLabel.text = tweet.user.screen_name
            let df = DateFormatter()
            df.dateStyle = .full
            df.timeStyle = .full
            let date = df.date(from: tweet.createdAtString)!
            df.dateStyle = .short
            df.timeStyle = .short
            dateLabel.text = df.string(from: date)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
