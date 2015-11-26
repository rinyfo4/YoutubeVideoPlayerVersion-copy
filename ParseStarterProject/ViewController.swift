//
//  ViewController.swift
//  
//
//  Created by Luka Ivicevic on 11/18/15.
//
//

import UIKit
import Social
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    
    var inviteRequests = PFObject(className: "inviteRequests")
    
    func displayAlert(title: String, message: String) {
    var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
    
    self.dismissViewControllerAnimated(true, completion: nil)
    
    })))
    
    self.presentViewController(alert, animated: true, completion: nil)
    
   }


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var permissionOutlet: UIButton!
    @IBAction func giveMePermission(sender: AnyObject) {
      
        if emailTextField.text == "" || nameTextField.text == ""  {
            
            displayAlert(":'(", message: "You didn't fill something out!")
            
            print("Not saved")
            
        } else {

        self.inviteRequests["email"] = emailTextField.text
        self.inviteRequests["name"] = nameTextField.text
            
            self.inviteRequests.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                self.inviteRequests.saveInBackground()
                print("Success is \(success)")
                
            } else {
                
                print(error)
                
                // There was a problem, check error.description
               
                
            }
        }
        
    }
        
        
    }
    @IBAction func tweetButton(sender: AnyObject) {
    
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print("print")
        // Do any additional setup after loading the view.
   
        self.emailTextField.delegate = self
        self.nameTextField.delegate = self
    }

    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        
        self.nameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        return true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
