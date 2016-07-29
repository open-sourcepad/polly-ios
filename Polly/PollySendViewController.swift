//
//  PollySendViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 29/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit
import MessageUI

class PollySendViewController: UIViewController, MFMailComposeViewControllerDelegate, PollyControllerDelegate {

    var textToView: NSDictionary = [:]
    
    //MARK: Lazy Variables
    private lazy var headerLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRectMake(0.0, 100.0, self.view.frame.size.width, 30.0))
        label.textColor = COLOR_POLLY_TEXT
        label.textAlignment = .Center
        label.text = "Where do you want to send the summary to?"
        label.font = CustomFont(FONT_DEFAULT, fontSize: 15.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var slackButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0.0, self.headerLabel.frame.origin.y + self.headerLabel.frame.size.height + 30.0, 117.0, 40.0))
        button.center = CGPointMake(self.view.center.x, button.center.y)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(UIImage(named: "slack"), forState: .Normal)
        button.addTarget(self, action: #selector(PollySendViewController.slackButtonAction(_:)), forControlEvents:.TouchUpInside)
        return button
    }()
    
    private lazy var emailButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0.0, self.slackButton.frame.origin.y + self.slackButton.frame.size.height + 10.0, 117.0, 40.0))
        button.center = CGPointMake(self.view.center.x, button.center.y)
        button.backgroundColor = UIColor.clearColor()
        button.setImage(UIImage(named: "email"), forState: .Normal)
        button.addTarget(self, action: #selector(PollySendViewController.emailButtonAction(_:)), forControlEvents:.TouchUpInside)
        return button
    }()
    
    private lazy var viewNowButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0.0, self.emailButton.frame.origin.y + self.emailButton.frame.size.height + 40.0, 220.0, 40.0))
        button.center = CGPointMake(self.view.center.x, button.center.y)
        button.backgroundColor = COLOR_POLLY_GREEN
        button.setTitle("View Now", forState: .Normal)
        button.titleLabel?.font = CustomFont(FONT_DEFAULT, fontSize: 18.0)
        button.setTitleColor(COLOR_POLLY_TEXT, forState: .Normal)
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(PollySendViewController.viewNowButtonAction(_:)), forControlEvents:.TouchUpInside)
        return button
    }()
    
    private lazy var restartButton: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0.0, self.viewNowButton.frame.origin.y + self.viewNowButton.frame.size.height + 60.0, 220.0, 40.0))
        button.center = CGPointMake(self.view.center.x, button.center.y)
        button.backgroundColor = COLOR_POLLY_THEME_LIGHT
        button.setTitle("Restart", forState: .Normal)
        button.titleLabel?.font = CustomFont(FONT_DEFAULT, fontSize: 18.0)
        button.setTitleColor(COLOR_POLLY_TEXT, forState: .Normal)
        button.layer.cornerRadius = 10.0
        button.addTarget(self, action: #selector(PollySendViewController.restartButtonAction(_:)), forControlEvents:.TouchUpInside)
        return button
    }()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(self.headerLabel)
        self.view.addSubview(self.slackButton)
        self.view.addSubview(self.emailButton)
        self.view.addSubview(self.viewNowButton)
        self.view.addSubview(self.restartButton)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Private Methods
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
    
        mailComposerVC.setSubject("Your summarized speech from Polly")
        
        let text = "Hello there\nHere is the full text copy of your \(textToView["title"]) meeting.\n\n \((textToView["text"] == nil ? "" : textToView["text"] as! String))"
        mailComposerVC.setMessageBody(text, isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", preferredStyle: .Alert)
        sendMailErrorAlert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }

    //MARK: - Button Actions
    func slackButtonAction(sender: AnyObject) {
        let pollyId: Int = textToView.objectForKey("id") as! Int
        PollyController.sharePollyOnSlack(pollyId, delegate: self)
    }

    func emailButtonAction(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func viewNowButtonAction(sender: AnyObject) {
        
        let webVC = WebViewController()
        webVC.text = textToView["text"] as! String
        webVC.pollyTitle = textToView["title"] as! String
        
        self.navigationController?.pushViewController(webVC, animated: true)
    }
    
    func restartButtonAction(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Polly Controller Delegate
    func pollyController(controller: PollyController, didFinishSharingOnSlackWithResponse response: AnyObject) {
        let alert = UIAlertController(title: "Shared!", message: "Your Polly has been shared on Slack.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func pollyController(controller: PollyController, didFailSharingOnSlackWithError error: NSError) {
        let alert = UIAlertController(title: "Cannot Share", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
