//
//  CounterCell.swift
//  twitter_alamofire_demo
//
//  Created by Samuel on 3/1/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit

class CounterCell: UITableViewCell {

    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var retweetCounter: UILabel!
    @IBOutlet weak var favoriteCounter: UILabel!
    @IBOutlet weak var favLabel: UILabel!
    
    var tweet: Tweet! {
        didSet{
            if(tweet.retweetCount != 1){
                retweetLabel.text = "Retweets"
            }
            if(tweet.favoriteCount! != 1){
                favLabel.text = "Favorites"
            }
            
            retweetCounter.text = formattedCounter(count: tweet.retweetCount)
            favoriteCounter.text = formattedCounter(count: tweet.favoriteCount!)
        }
    }
    
    func formattedCounter(count: Int) -> String{
        var formattedCount = ""
        // Billion, just in case
        if(count >= 1000000000){
            formattedCount = String(format: "%.1fb", Double(count) / 1000000000.0)
        }
        else if(count >= 1000000){
            formattedCount = String(format: "%.1fm", Double(count) / 1000000.0)
        }
        else if(count >= 10000){
            formattedCount = String(format: "%.1fk", Double(count) / 1000.0)
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
