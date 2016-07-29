//
//  PollyTitleViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 29/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit

class PollyTitleViewController: UIViewController, UITextFieldDelegate, PollyControllerDelegate {
    
    var audioUrl: NSURL = NSURL(string: "")!

    private lazy var titleLabel: UILabel = {
        let label: UILabel = UILabel(frame: CGRectMake(0.0, 100.0, self.view.frame.size.width, 30.0))
        label.textColor = COLOR_POLLY_TEXT
        label.textAlignment = .Center
        label.text = "Title:"
        label.font = UIFont.boldSystemFontOfSize(18.0)
        return label
    }()
    
    private lazy var titleTextField: UITextField = {
        let tf: UITextField = UITextField(frame: CGRectMake(30.0, 150.0, self.view.frame.size.width-60.0, 50.0))
        tf.font = UIFont.systemFontOfSize(25.0)
        tf.textColor = COLOR_POLLY_TEXT
        tf.delegate = self
        tf.borderStyle = .RoundedRect
        tf.placeholder = "Enter Title"
        tf.returnKeyType = .Done
        tf.becomeFirstResponder()
        return tf
    }()
    
    private lazy var loadingView: UIImageView = {
        let imageView : UIImageView = UIImageView(frame: CGRectMake(0.0, 0.0, 182.0, 147.0))
        imageView.center = CGPointMake(self.view.center.x, self.view.center.y)
        imageView.image = UIImage(named: "loading")
        imageView.hidden = true
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleTextField)
        self.view.addSubview(self.loadingView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        var pollyTitle = titleTextField.text
        if pollyTitle == "" {
            pollyTitle = "Polly\(NSDate.timeIntervalSinceReferenceDate())"
        }
        
        PollyController.uploadFile(audioUrl, title: pollyTitle!, delegate: self)
        self.view.userInteractionEnabled = false
        
        // Show loading
        self.loadingView.hidden = false
        self.titleLabel.hidden = true
        self.titleTextField.hidden = true
        return true
    }

    //MARK: Polly Delegate
    func pollyController(controller: PollyController, didFinishUploadingWithResponse response: AnyObject) {
        print("success: \(response)")
        self.view.userInteractionEnabled = true
        
        let vc : PollySendViewController = PollySendViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func pollyController(controller: PollyController, didFailUploadWithError error: NSError) {
        print("error: \(error)")
        self.view.userInteractionEnabled = true
    }
}
