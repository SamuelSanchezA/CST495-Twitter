//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Samuel on 3/2/18.
//  Copyright © 2018 Charles Hieger. All rights reserved.
//

import UIKit
import RSKPlaceholderTextView

protocol ComposeViewControllerDelegate : NSObjectProtocol {
   
    func did(post: Tweet)
}

class ComposeViewController: UIViewController, UITextViewDelegate{
    
    @IBOutlet weak var tweetBox: RSKPlaceholderTextView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tweetButton: UIButton!
    
    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetButton.isUserInteractionEnabled = false
        tweetButton.setTitleColor(UIColor.gray, for: .normal)
        tweetBox.placeholder = "What's happening?"
        profileImageView.af_setImage(withURL: (User.current?.profile_url)!)
        profileImageView.layer.cornerRadius = 35
        profileImageView.clipsToBounds = true
        screennameLabel.text = "@\(User.current?.screen_name ?? "Unknown")"
        usernameLabel.text = User.current?.name
        tweetBox.becomeFirstResponder()
        tweetBox.delegate = self
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        if(textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty){
            tweetButton.isUserInteractionEnabled = false
            tweetButton.setTitleColor(UIColor.gray, for: .normal)
        }
        else{
            tweetButton.isUserInteractionEnabled = true
            tweetButton.setTitleColor(UIColor.white, for: .normal)
        }
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        //Tweet then dismiss
        APIManager.shared.composeTweet(with: tweetBox.text) { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.did(post: tweet)
                print("Compose Tweet Success!")
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
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

