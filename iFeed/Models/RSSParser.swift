//
//  RSSFeed.swift
//  iFeed
//
//  Created by Tarokh on 8/19/20.
//  Copyright © 2020 Tarokh. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireRSSParser

public enum NetWorkResponseStatus {
    case success
    case error(error: String?)
}

public class RSSParser {
    
    public static func getRSSFeed(rss: String, completionHandler: @escaping (_ response: RSSFeed?, _ status: NetWorkResponseStatus) -> Void) {
        AF.request(rss).responseRSS { (response) in
            if let rssFeedXML = response.value {
                completionHandler(rssFeedXML, .success)
            }
            else {
                completionHandler(nil , .error(error: response.error?.localizedDescription))
            }
        }
    }
    
}
