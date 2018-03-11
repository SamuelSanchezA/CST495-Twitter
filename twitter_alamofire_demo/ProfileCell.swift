//
//  ProfileCell.swift
//  twitter_alamofire_demo
//
//  Created by Samuel on 3/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followersLabel: UILabel!
    
    var user : User! {
        didSet{
            bannerImageView.af_setImage(withURL: user.banner_url)
            profileImageView.af_setImage(withURL: user.profile_url)
            profileImageView.layer.cornerRadius = 34
            profileImageView.clipsToBounds = true
            usernameLabel.text = user.name
            screennameLabel.text = "@\(user.screen_name)"
            descriptionLabel.text = user.description
            locationLabel.text = user.location
            followersCountLabel.text = formattedCounter(count: user.followers!)
            followingCountLabel.text = formattedCounter(count: user.following!)
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
