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
    
    // Get Pollies
    class func getPollies(delegate: AnyObject) {
        let controller = self.getInstance()
        controller.delegate = delegate
        controller.getPollies()
    }
    
    class func sharePollyOnSlack(pollyId: Int, delegate: AnyObject) {
        let controller = self.getInstance()
        controller.delegate = delegate
        controller.shareOnSlack(pollyId)
    }
    
    private func uploadFile(fileUrl: NSURL, title: String) {
        
        // Show network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let manager = Alamofire.Manager.sharedInstance
        
        manager.upload(
            .POST,
            API_BASE_URL + API_ENDPOINT_SPEECHES,
            multipartFormData: { multipartFormData in
                multipartFormData.appendBodyPart(fileURL: fileUrl, name: "file")
                multipartFormData.appendBodyPart(data: (title as NSString).dataUsingEncoding(NSUTF8StringEncoding)!, name: "title")
            },
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                        
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
                        
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        )
        
    }
    
    private func getPollies() {
        
        // Show network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let manager = Alamofire.Manager.sharedInstance
        
        manager.request(.GET, API_BASE_URL + API_ENDPOINT_SPEECHES, parameters: nil, encoding: .URL, headers: nil)
            .responseJSON(completionHandler: { response in
                switch response.result {
                case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
                    
                    let response = JSON as! NSArray
                    
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFinishGetPolliesWithResponse:))) {
                        self.delegate!.pollyController!(self, didFinishGetPolliesWithResponse: response)
                    }
                    
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                    
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFailGetPolliesWithError:))) {
                        self.delegate!.pollyController!(self, didFailGetPolliesWithError: error)
                    }
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }
    
    private func shareOnSlack(pollyId: Int) {
        
        let params = ["id": pollyId]
        
        // Show network indicator
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        let manager = Alamofire.Manager.sharedInstance
        
        manager.request(.POST, API_BASE_URL + API_ENDPOINT_SLACK, parameters: params, encoding: .URL)
            .responseJSON(options: NSJSONReadingOptions.AllowFragments, completionHandler: { response in
                switch response.result {
                case .Success(let data):
                    print(data)
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFinishSharingOnSlackWithResponse:))) {
                        self.delegate!.pollyController!(self, didFinishSharingOnSlackWithResponse: data)
                    }
                case .Failure(let error):
                    print(error)
                    if self.delegate!.respondsToSelector(#selector(PollyControllerDelegate.pollyController(_:didFailSharingOnSlackWithError:))) {
                        self.delegate!.pollyController!(self, didFailSharingOnSlackWithError: error)
                    }
                    
                }
                // Hide network indicator
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
    }
}

//MARK: - Delegate
@objc protocol PollyControllerDelegate {
    
    optional func pollyController(controller: PollyController, didFinishUploadingWithResponse response:AnyObject)
    optional func pollyController(controller: PollyController, didFailUploadWithError error:NSError)
    
    optional func pollyController(controller: PollyController, didFinishGetPolliesWithResponse response:AnyObject)
    optional func pollyController(controller: PollyController, didFailGetPolliesWithError error:NSError)
    
    optional func pollyController(controller: PollyController, didFinishSharingOnSlackWithResponse response:AnyObject)
    optional func pollyController(controller: PollyController, didFailSharingOnSlackWithError error:NSError)
}