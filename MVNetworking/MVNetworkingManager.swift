//
//  MVNetworkingManager.swift
//  MVNetworking
//
//  Created by Michael on 6/3/14.
//  Copyright (c) 2014 __MICHAEL_VOZNESENSKY__. All rights reserved.
//

import Foundation

protocol MVNetworkingManagerResponsesDelegate {
    func responseDidComeBack ()
}


class NetworkingManagerSingleton {
    var delegate : MVNetworkingManagerResponsesDelegate?
    
    class var sharedInstance:NetworkingManagerSingleton{
        get {
            struct Static {
                static var instance : NetworkingManagerSingleton? = nil
                static var token : dispatch_once_t = 0;
                
            }
            
            dispatch_once(&Static.token) {
                Static.instance = NetworkingManagerSingleton()
            }
            return Static.instance!;
        }
    }
    
    func POSTData (urlStringForConnection:String, httpBodyDictionary:Dictionary <String, String>){
        let sampleUrl : NSURL = .URLWithString(urlStringForConnection)
        var request = NSMutableURLRequest(URL: sampleUrl)
        let queue = NSOperationQueue()
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        var localClassErrorNetworking: NSError?
        
        request.addValue("application/json", forHTTPHeaderField:"Content-Type")
        request.addValue("application/json", forHTTPHeaderField:"Accept")
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(httpBodyDictionary, options: NSJSONWritingOptions(),error: &localClassErrorNetworking)
        request.HTTPMethod = "POST"
        println("request is \(request.HTTPMethod)")
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest( request, completionHandler:{ (data : NSData!, response: NSURLResponse!, error : NSError!) -> Void in

            let byteString : AnyObject = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &localClassErrorNetworking)

                println("data string is : \(byteString)")
                //Need Delegate
//            var delegate : MVNetworkingManagerResponsesDelegate
//                delegate.responseDidComeBack()
            })
        self.delegate?.responseDidComeBack()
        task.resume()
    }

}


