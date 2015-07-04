//
//  PostTableViewCell.swift
//  Makestagram
//
//  Created by Ryan Kim on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likesIconImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreButton: UIButton!
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        
    }
    @IBAction func likeButtonTapped(sender: AnyObject) {
        post?.toggleLikePost(PFUser.currentUser()!)
    }
    
    var post:Post? {
        didSet {
            if let post = post {
                //not sure here
                post.image ->> postImageView
                post.likes ->> likeBond
            }
        }
    }
    var likeBond: Bond<[PFUser]?>!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
            if let likeList = likeList {
                self.likesLabel.text = self.stringFromUserList(likeList)
                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
                self.likesIconImageView.hidden = (likeList.count == 0)
            } else {
                self.likesLabel.text = ""
                self.likeButton.selected = false
                self.likesIconImageView.hidden = true
            }
        }
    }
    
    
    func stringFromUserList(userList: [PFUser]) -> String {
        let usernameList = userList.map { user in user.username!}
        let commaSeparatedUserList = ", ".join(usernameList)
        
        return commaSeparatedUserList
    }
    
    
    
    
    
    
    
    

}
