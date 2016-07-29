//
//  PollyTitleViewController.swift
//  Polly
//
//  Created by Nikki Fernandez on 29/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit

class PollyTitleViewController: UIViewController, UITextFieldDelegate {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.titleTextField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK - TextField Delegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        // Send to API...
        
        let vc : PollySendViewController = PollySendViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
        return true
    }

}