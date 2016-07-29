//
//  PollyController.swift
//  Polly
//
//  Created by Nikki Fernandez on 29/07/2016.
//  Copyright © 2016 SourcePad. All rights reserved.
//

import UIKit
import Alamofire

private var singleton: PollyController?

class PollyController: NSObject {
    var delegate: AnyObject?
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    //MARK: - Private methods
    private class func getInstance() -> PollyController {
        if singleton == nil {
            return PollyController()
        }
        return singleton!
    }
    
    //MARK: - Public class methods
    // Upload audio
    class func uploadAudio(title: NSString, audioUrl: NSURL, delegate: AnyObject) {
        let controller = self.getInstance()
        controller.delegate = delegate
        controller.uploadAudio(title, audioUrl: audioUrl)
    }
    
    private func uploadAudio(title: NSString, audioUrl: NSURL) {
//        let params = [
//            "title": title,
//        ]
        
        // Show network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
//        let manager = Alamofire.Manager.sharedInstance
//        manager.request(.POST, "", parameters: params, encoding: .URL)
//            .responseJSON(options: NSJSONReadingOptions.AllowFragments, completionHandler: { (request, response, result) -> Void in
//                
//                print("\(request)\n\(params)")
//                
//                switch result {
//                case .Success(let data):
//                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController())) {
//                        self.delegate!.userController!(self, didFinishSignUpSocialWithResponse: data, hasEmail:(user.email! != ""))
//                    }
//                    
//                case .Failure(_, let error as NSError):
//                    print(error)
//                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.userController(_:didFailSignUpSocialWithError:))) {
//                        self.delegate!.userController!(self, didFailSignUpSocialWithError: error)
//                    }
//                    
//                default: ()
//                }
//                // Hide network indicator
//                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//            })
    }
}

@objc protocol PollyControllerDelegate {
    
    optional func pollyController(controller: PollyController, didFinishUploading response:AnyObject)
    optional func pollyController(controller: PollyController, didFinishUploadingWithError error:NSError)
}
