//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Ryan Kim on 6/29/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class TimelineViewController: UIViewController, TimelineComponentTarget {
    @IBOutlet weak var tableView: UITableView!
    var photoTakingHelper: PhotoTakingHelper?
    var posts: [Post] = []
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestforCurrentUser {
            (result: [AnyObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
            
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func takephoto() {
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let post = Post()
            post.image.value = image!
            post.uploadPost()
        }
    }
    
    func loadInRange(range:Range<Int>, completionBlock: ([Post]?) -> Void) {
    
    ParseHelper.timelineRequestforCurrentUser(range) {
    (result: [AnyObject]?, error: NSError?) -> Void in
        let posts = result as? [Post] ?? []
        completionBlock(posts)
        }
    }
    

    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}

//MARK: Tab Bar Delegate

extension TimelineViewController : UITabBarControllerDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
            takephoto()
            return false
        } else {
            return true
        }
    }
}

extension TimelineViewController : UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        let post = posts[indexPath.row]
        post.downloadImage()
        post.fetchLikes()
        cell.post = post
        
        return cell
    }
}

public protocol TimelineComponentTarget: class {
    typealias ContentType
    
    var defaultRange: Range<Int> { get }
    var additionalRangeSize: Int { get }
    var tableView: UITableView! { get }
    func loadInRange(range:Range<Int>, completionBlock: ([ContentType]?) -> Void)
}
