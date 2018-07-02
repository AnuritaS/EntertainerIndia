//
//  RefTokenRes.swift
//  Entertainer
//
//  Created by Nikhil Bansal on 05/03/18.
//  Copyright © 2018 Shubhankar Singh. All rights reserved.
//

import Foundation
import ObjectMapper

class RefTokenRes : NSObject, NSCoding, Mappable{
    
    var authToken : String?
    var code : Int?
    var refToken : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return RefTokenRes()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        authToken <- map["authToken"]
        code <- map["code"]
        refToken <- map["refToken"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        authToken = aDecoder.decodeObject(forKey: "authToken") as? String
        code = aDecoder.decodeObject(forKey: "code") as? Int
        refToken = aDecoder.decodeObject(forKey: "refToken") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if authToken != nil{
            aCoder.encode(authToken, forKey: "authToken")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if refToken != nil{
            aCoder.encode(refToken, forKey: "refToken")
        }
        
    }
    
}
