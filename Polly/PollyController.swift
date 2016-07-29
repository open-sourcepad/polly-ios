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
    
    // Upload Recording
    class func uploadFile(fileUrl: NSURL, title: String, delegate: AnyObject) {
        let controller = self.getInstance()
        controller.delegate = delegate
        controller.uploadFile(fileUrl, title: title)
    }
    
    // Sign up/sign in user via social network
    private func uploadFile(fileUrl: NSURL, title: String) {
        // Show network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let request = NSMutableURLRequest(URL: NSURL(string: API_BASE_URL + API_ENDPOINT_UPLOAD)!)
        
        let jsonData = try? NSJSONSerialization.dataWithJSONObject(["title": title], options: .PrettyPrinted)
        request.HTTPBody = jsonData
        
        let manager = Alamofire.Manager.sharedInstance
        manager.upload(.POST, request, file: fileUrl)
            .progress { bytesWritten, totalBytesWritten, totalBytesExpectedToWrite in
                print(totalBytesWritten)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    print("Total bytes written on main queue: \(totalBytesWritten)")
                }
            }
            .validate()
            .responseJSON { response in
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSDictionary
                    
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFinishUploadingWithResponse:))) {
                        self.delegate!.pollyController!(self, didFinishUploadingWithResponse: response)
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFailUploadWithError:))) {
                        self.delegate!.pollyController!(self, didFailUploadWithError: error)
                    }
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
        }
        
    }
}

//MARK: - Delegate
@objc protocol PollyControllerDelegate {
    
    optional func pollyController(controller: PollyController, didFinishUploadingWithResponse response:AnyObject)
    optional func pollyController(controller: PollyController, didFailUploadWithError error:NSError)
}