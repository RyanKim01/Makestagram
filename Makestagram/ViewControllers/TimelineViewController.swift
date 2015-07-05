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
    let defaultRange = 0...4
    let additionalRangeSize = 5
    var timelineComponent: TimelineComponent <Post, TimelineViewController>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timelineComponent = TimelineComponent(target: self)
        self.tabBarController?.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        TimelineComponent.loadInitialIfRequired()
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
    
func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
    // 1
    ParseHelper.timelineRequestforCurrentUser(range) {
        (result: [AnyObject]?, error: NSError?) -> Void in
        // 2
        let posts = result as? [Post] ?? []
        // 3
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
        return timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        let post = timelineComponent.content[indexPath.row]
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

extension TimelineViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        TimelineComponent.targetWillDisplayEntry(indexPath.row)
    }
}
