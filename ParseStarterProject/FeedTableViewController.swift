//
//  FeedTableViewController.swift
//  ParseStarterProject-Swift
//
//  Created by Luka Ivicevic on 11/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import ParseUI
import Parse
import WebKit
import AVFoundation
import AVKit

public var AudioPlayer = AVPlayer()
public var SelectedSongNumber = Int()

public var idArray = [String]()


class FeedTableViewController: PFQueryTableViewController, AVAudioPlayerDelegate {
    
    var pressedPlay = true

    let cellIdentifier:String = "MusicCell"
    var idArray = [String]()

    var refresher: UIRefreshControl?

    override func viewDidLoad() {
        self.tableView.allowsSelection = false
        self.tableView.rowHeight = 200
        self.pullToRefreshEnabled = false

        
        tableView.registerNib(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellIdentifier)
        super.viewDidLoad()
        var query = PFQuery(className: "Music")
        query.findObjectsInBackgroundWithBlock ({
            (objectsArray: [PFObject]?, error: NSError?) -> Void in
            
            
            if let objects = objectsArray {
                
                self.idArray.removeAll(keepCapacity: true)
                
                
                var objectIDs = objectsArray!
                
                for i in 0...objectIDs.count-1 {
                    
                    self.idArray.append(objectIDs[i].valueForKey("objectId") as! String)
                  
                    self.tableView.reloadData()
                    
                }
            }
        })
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
           // self.pullToRefreshEnabled = false
            
            self.refresher?.endRefreshing()
            

            
            
            alert.show()
        }

    
        refresher = UIRefreshControl()
        
        self.refresher!.attributedTitle = NSAttributedString(string: "Refresh :D")
        
        self.refresher!.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        self.tableView.addSubview(self.refresher!)
        
        refresh()
    }
    
    func refresh() {
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
             self.pullToRefreshEnabled = false
            
            self.refresher?.endRefreshing()
            
            
            
            
            alert.show()
        }
        self.reloadInputViews()
        self.refresher!.endRefreshing()
    }

    
  
    func grabSong () {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            
            
            var songQuery = PFQuery(className: "Music")
            songQuery.getObjectInBackgroundWithId(idArray[SelectedSongNumber], block: {
                (objects: PFObject?, error : NSError?) -> Void in
                
                
                
                if let audioFile = objects!["musicFile"] as? PFFile {
                    let audioFileUrlString: String = audioFile.url!
                    let audioFileUrl = NSURL(string: audioFileUrlString)!
                    AudioPlayer = AVPlayer(URL: audioFileUrl)
                    AudioPlayer.play()
                }
                
            })

            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
            
            
            alert.show()
        }

        
        
    }
    
    
    override func queryForTable() -> PFQuery {
        var query:PFQuery = PFQuery(className:"Music")
        
        if(objects?.count == 0)
        {
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        }
        
        query.orderByAscending("musicFile")
        
        return query
    }
    
    
   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
       
        var cell: FeedTableViewCell? = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? FeedTableViewCell

        
        if(cell == nil) {
            cell = NSBundle.mainBundle().loadNibNamed("FeedTableViewCell", owner: self, options: nil)[0] as? FeedTableViewCell

        
        }

            if let pfObject = object {
               
                cell?.parseObject = object

                cell?.songName?.text = pfObject["songName"] as? String
                
                cell?.artistName?.text = pfObject["artistName"] as? String
                
             //   cell?.genre?.text = pfObject["genre"] as? String
                
                var votes:Int? = pfObject["votes"] as? Int
                if votes == nil {
                    votes = 0
        }
                cell?.votesLabel?.text = "\(votes!)"


                cell?.playOutlet.tag = indexPath.row
                cell?.playOutlet.addTarget(self, action: "play:", forControlEvents: .TouchUpInside)
                print("Cell Tag \(cell?.playOutlet.tag)")
                
                
                cell?.nameOfUserWhoAdded.text = pfObject["addedBy"] as? String
                
                
                cell?.userWhoAddedSong?.image = nil
                if var urlString:String? = pfObject["photoOfUser"] as? String {
                    
                    if var url:NSURL? = NSURL(string: urlString!) {
                        var error:NSError?
                        var request:NSURLRequest = NSURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.ReturnCacheDataElseLoad, timeoutInterval: 5.0)
                        
                        NSOperationQueue.mainQueue().cancelAllOperations()
                        
                        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler: {
                            (response, imageData, error) -> Void in
                            
                            (cell?.userWhoAddedSong?.image = UIImage(data: imageData!))!
                            
                        })
                    }
                }
                
                
                
                var createdAt =  pfObject.createdAt
                if createdAt != nil {
                    let calendar = NSCalendar.currentCalendar()
                    let comps = calendar.components([.Day, .Month, .Year, .Hour, .Minute, .Second], fromDate: createdAt as NSDate!)
                    let hours = comps.hour
                   /* let minutes = comps.minute
                    let seconds = comps.second
                    let day = comps.day
                    let month = comps.month
                    let year = comps.year */
                
                    cell?.timeLabel.text = "@ \(String(format: "%02dh", hours))"
                    
                
                }
        
        }

        return cell
    
        }
    
  
  
    
    func play(sender: AnyObject) {

        if pressedPlay == true {
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(position)
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath!)! as!
        FeedTableViewCell
        print(indexPath?.row)
        print("Button tapped")
            
            if indexPath!.row == indexPath?.row {
             
            print("same index")
                
            } else if indexPath!.row != indexPath?.row {
             
                print("different index")
            }
            SelectedSongNumber = (indexPath?.row)!
        
            grabSong()
            print("play")
            
            pressedPlay = false
        } else {
         
            AudioPlayer.pause()
            
            print("pause")
            
            pressedPlay = true

        }
        
        
            
        
    }
    

    
    func pause(sender: AnyObject) {
        
        if pressedPlay == false {
        
        var position: CGPoint = sender.convertPoint(CGPointZero, toView: self.tableView)
        let indexPath = self.tableView.indexPathForRowAtPoint(position)
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath!)! as!
        FeedTableViewCell
        print(indexPath?.row)
        print("Button tapped")
            
            AudioPlayer.pause()
            
        }
        
    }


    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}








/* var credit:String? = pfObject["cc_by"] as? String
if credit != nil {
cell?.catCreditLabel?.text = "\(credit!) / CC 2.0"
}*/







/* CHANGES MADE ***************************************************



-Took away bool value from Main Storyboard for pull to refresh from this VC.
-Added my own refresh 
-Added internet check points Reachability on ALL buttons***

check to see if it works without the error handling!  



*/









