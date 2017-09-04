//
//  AboutViewController.swift
//  medication-reminder
//
//  Created by Francisco Campos on 2017-09-03.
//  Copyright © 2017 Vikas Gandhi. All rights reserved.
//

import UIKit
import Social

/// Controller for AboutViews
class AboutViewController: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Push button to post to Facebook
    ///
    /// - Parameter sender: send a UIButton
    @IBAction func postToFacebookButton(_ sender: UIButton)
    {
        postSocial(toService: SLServiceTypeFacebook)
    }
    
    /// Push button to post to Twitter
    ///
    /// - Parameter sender: send a UIButton
    @IBAction func postToTwitterButton(_ sender: UIButton)
    {
        postSocial(toService: SLServiceTypeTwitter)
    }
    
    /// Post to Social Networks
    ///
    /// - Parameter service: Tells which social service
    func postSocial(toService service: String)
    {
        if(SLComposeViewController.isAvailable(forServiceType: service))
        {
            let socialController = SLComposeViewController(forServiceType: service)
            socialController?.setInitialText("Medication Reminder by Francisco Campos!. Make sure to check my work")
            let imageName = "ico_1024x1024.png"
            let image = UIImage(named: imageName)
            socialController?.add(image)
            let url = URL(string: "https://itunes.apple.com/us/developer/francisco-campos/id633373329")
            socialController?.add(url)
            self.present(socialController!, animated: true, completion: nil)
        }
        else
        {
            createAlert(title: "Configure Social Networks", message: "In order to share configure your social Networks first")
        }
    }
    
    /// Create Alert
    ///
    /// - Parameters:
    ///   - title: String to add as a Title in popup
    ///   - message: String to add as Message in popup
    func createAlert (title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }
}


