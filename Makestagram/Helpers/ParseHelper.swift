//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Ryan Kim on 7/1/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {
    //following Relation
    static let ParseFollowClass = "Follow"
    static let ParseFollowFromUser = "fromUser"
    static let ParseFollowToUser = "toUser"
    
    //like Relation
    static let ParseLikeClass = "Like"
    static let ParseLikeToPost = "toPost"
    static let ParseLikeFromUser = "fromUser"
    
    //post relation
    static let ParsePostUser = "user"
    static let ParsePostCreatedAt = "createdAt"
    
    //flagged content relation
    static let ParseFlaggedContentClass = "FlaggedContent"
    static let ParseFlaggedContentFromUser = "fromUser"
    static let ParseFlaggedContentToPost = "toPost"
    
    //user relation
    static let ParseUserUsername = "username"
    
    
    static func timelineRequestforCurrentUser (completionBlock: PFArrayResultBlock) {
        let followingQuery = PFQuery(className: ParseFollowClass)
        followingQuery.whereKey(ParseLikeFromUser, equalTo:PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey(ParsePostUser, matchesKey: ParseFollowToUser, inQuery: followingQuery)
        
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey(ParsePostUser, equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        query.includeKey(ParsePostUser)
        query.orderByDescending(ParsePostCreatedAt)
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
}
}