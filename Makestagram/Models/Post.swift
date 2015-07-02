//
//  Post.swift
//  Makestagram
//
//  Created by Ryan Kim on 6/30/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import Parse
import Bond

class Post : PFObject, PFSubclassing {
    
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    var image: Dynamic<UIImage?> = Dynamic(nil)
    var photoUploadTask : UIBackgroundTaskIdentifier?
    
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
        let imageData = UIImageJPEGRepresentation(image.value, 0.8)
        let imageFile = PFFile(data: imageData)
        
        photoUploadTask = UIApplication.sharedApplication().beginBackgroundTaskWithExpirationHandler { () -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!) }
        
        //        This is same code as the one below.
        //        imageFile.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) -> Void in
        //            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!) })
        
        imageFile.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            UIApplication.sharedApplication().endBackgroundTask(self.photoUploadTask!) }
        
        
        user = PFUser.currentUser()
        self.imageFile = imageFile
        saveInBackgroundWithBlock(nil)
    }
    
    func downloadImage() {
        if (image.value == nil) {
            imageFile?.getDataInBackgroundWithBlock { (data: NSData?, error: NSError) -> Void in
                if let data = data {
                    let image = UIImage(data: data, scale: 1.0)!
                    self.image.value = image
                }
            }
        }
    }
    
    
}
