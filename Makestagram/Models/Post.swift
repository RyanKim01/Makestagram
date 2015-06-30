//
//  Post.swift
//  Makestagram
//
//  Created by Ryan Kim on 6/30/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse

class Post : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    var image: UIImage?
    
    //MARK: PFSubclassing Protocol
    
    static func parseClassName() -> String {
        return "Post"
    }
    
    override init() {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }

    func uploadPost() {
        let imageData = UIImageJPEGRepresentation(image, 0.8)
        let imageFile = PFFile(data: imageData)
        imageFile.saveInBackgroundWithBlock(nil)
        
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)
        
    }
 
    
    
}
