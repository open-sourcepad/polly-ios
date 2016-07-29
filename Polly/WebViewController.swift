//
//  WebViewController.swift
//  
//
//  Created by Aj Fermin on 29/07/2016.
//
//

import UIKit

class WebViewController: UIViewController {
    
    var text: String = ""
    var pollyTitle: String = ""
    
    //MARK: - Lazy variables
    private lazy var labelFullText: UILabel = {
        let labelFullText: UILabel = UILabel(frame: CGRectMake(15, 0.0, SCREEN_WIDTH, 40.0))
        labelFullText.backgroundColor = UIColor.whiteColor()
        labelFullText.font = CustomFont(FONT_TITLE, fontSize: 14)
        labelFullText.text = "Full Text"
        return labelFullText
    }()
    
    private lazy var textView: UITextView = {
        let textView: UITextView = UITextView(frame: CGRectMake(15, 48.0, SCREEN_WIDTH, self.view.frame.height-40))
        textView.backgroundColor = UIColor.whiteColor()
        textView.font = CustomFont(FONT_DEFAULT, fontSize: 12)
        textView.selectable = false
        textView.editable = false

        return textView
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loadingIndicator.center = self.view.center
        loadingIndicator.color = COLOR_POLLY_PINK
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }()
    
    // MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        
        textView.text = text
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Private methods
    func configureView() {
        self.edgesForExtendedLayout = .None
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = pollyTitle
        
        self.view.addSubview(labelFullText)
        self.view.addSubview(textView)
        self.view.addSubview(loadingIndicator)
    }
    
}