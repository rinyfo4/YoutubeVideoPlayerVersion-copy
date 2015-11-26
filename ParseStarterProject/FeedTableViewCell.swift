//
//  MusicTableViewCell.swift
//  LaTuneParseAttempt2
//
//  Created by Luka Ivicevic on 11/9/15.
//  Copyright © 2015 jaysl. All rights reserved.
//

import UIKit
import Parse
import ParseUI 
import AVFoundation
import AVKit

class FeedTableViewCell: PFTableViewCell, AVAudioPlayerDelegate {
    var parseObject:PFObject?
    
    var pressedPlay = true
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var votesLabel: UILabel!
    @IBOutlet weak var nameOfUserWhoAdded: UILabel!
    @IBOutlet weak var heartOutlet: UIButton!
    @IBAction func heartButton(sender: AnyObject) {
        
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")

            
            if(parseObject != nil) {
                if var votes:Int? = parseObject!.objectForKey("votes") as? Int {
                    votes!++
                    
                    parseObject!.setObject(votes!, forKey: "votes")
                    parseObject!.saveInBackground()
                    
                    votesLabel?.text = "\(votes!)"
                }
            }
            
            heartOutlet.enabled = false

            
            
            
            
        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
            // self.pullToRefreshEnabled = false
            
            
            
            
            
            alert.show()
        }
        

        
        
    }
    
    
    @IBAction func shareButton(sender: AnyObject) {
   
        if Reachability.isConnectedToNetwork() == true {
            print("Internet connection OK")
            presentVC()

        } else {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "Woops! No Internet Connection :(", message: "Make sure your iPhone is connected to the internet!", delegate: nil, cancelButtonTitle: "OK")
            // self.pullToRefreshEnabled = false
            
            
            
            
            
            alert.show()
        }

        
        
        //presentVC()
    }
    
    @IBOutlet weak var playOutlet: UIButton!
    
    @IBAction func playPauseButton(sender: AnyObject) {
    
        if pressedPlay == true {
            
            let button = sender as! UIButton
            var indexPath =   self.window?.rootViewController!.indexOfAccessibilityElement(playOutlet)

            

            var pauseImage: UIImage = UIImage(named: "pause31.png")!
            
            playOutlet.setImage(pauseImage, forState: .Normal)
            
            
            pressedPlay = false
            
            print("cellPlay")
            
            
        } else {
            

            var playImage:UIImage = UIImage(named: "play102.png")!
            
            playOutlet.setImage(playImage, forState: .Normal)
            pressedPlay = true
            
            AudioPlayer.pause()
            print("stopCell")


        }

    
        
    }
    
    
    
    @IBOutlet weak var pauseOutlet: UIButton!
    
   

    
    

    
    @IBOutlet weak var userWhoAddedSong: UIImageView!
    
    
    func presentWebVC() {
        
        
           // self.window?.rootViewController!.presentViewController(activityVC, animated: true, completion: nil)
        }

     
        
        
    
    
    func presentVC () {
        let textToShare = "Swift is awesome!  Check out this website about it!"
        
        if let myWebsite = NSURL(string: "http://www.codingexplorer.com/")
        {
            let objectsToShare = [textToShare, myWebsite]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            self.window?.rootViewController!.presentViewController(activityVC, animated: true, completion: nil)
        }
        
    }
    
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
        
        
        
    }
    
}

//STACKOVERFLOW QUESTION

/* 
I have a custom tableViewCell button that changes images from PLAY to PAUSE  when it's tapped.

**Logic Issue:** When I'm switching songs while one song is playing and the button is set to the "pause" image, the image stays the same and doesn't change when I click another cell's button.

I'm having difficulty figuring out the logic for: when I click another cell, the original cell that was playing a track resets to the original image and settings: the PLAY button instead of the PAUSE button.

Here is what I have in my `cellForRowAtIndexPath` where I'm setting a "play" function:

cell?.playOutlet.tag = indexPath.row
cell?.playOutlet.addTarget(self, action: "play:", forControlEvents: .TouchUpInside)

I have a `play` function that plays the song + queries it. Should I do the image settings there?

Here is my Custom Cell code for switching the images back and forth:



@IBAction func playPauseButton(sender: AnyObject) {

if pressedPlay == true {

let button = sender as! UIButton

var pauseImage: UIImage = UIImage(named: "pause31.png")!

playOutlet.setImage(pauseImage, forState: .Normal)

pressedPlay = false

print("cellPlay")


} else {

var playImage:UIImage = UIImage(named: "play102.png")!

playOutlet.setImage(playImage, forState: .Normal)
pressedPlay = true

AudioPlayer.pause()
print("stopCell")
}
}

I'm assuming I need to reset the settings of the original cell in the custom cell. I can't figure out the logic how to reset it.

Any ideas thoughts or comments mean a lot.

Thanks


*/
