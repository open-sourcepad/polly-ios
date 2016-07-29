//
//  PollySendViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 29/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit

class PollySendViewController: UIViewController {

    var delegate: AnyObject?
    var textToView: String = ""
    
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
    

    //MARK - Button Actions
    func slackButtonAction(sender: AnyObject) {
        
    }

    func emailButtonAction(sender: AnyObject) {
        
    }
    
    func viewNowButtonAction(sender: AnyObject) {
        self.delegate!.pollyWillViewRecordedText!(textToView)
    }
    
    func restartButtonAction(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
}

//MARK: - Delegate
@objc protocol PollySendViewControllerDelegate {
    optional func pollyWillViewRecordedText(textToView: String)
}
