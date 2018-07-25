//
//  TPServiceManager.swift
//  TourPedia
//
//  Created by Shebin Koshy on 26/03/18.
//  Copyright © 2018 Shebin Koshy. All rights reserved.
//

import Foundation


class TPServiceManager: NSObject {
    
    public typealias ResponseHandler = (Data?,Bool) -> Swift.Void
    
    public class func webservice(urlString:String, httpMethod:String, headerFields:Array<Dictionary<String,String>>, body:Data?, responseHandler:@escaping ResponseHandler){
        let session = URLSession.shared
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        for header in headerFields {
            for key in header.keys {
                request.addValue(header[key]!, forHTTPHeaderField: key)
            }
        }
        request.httpBody = body
        
        let dataTask = session.dataTask(with: request) { (data:Data?, response:URLResponse?, error:Error?) in
            if error != nil {
                responseHandler(nil, false)
                return
            }
            if data != nil {
                responseHandler(data! ,true)
            }
            
        }
        dataTask.resume()
    }
    
}
