//
//	NewUserProfile.swift
//
//	Create by Nikhil Bansal on 4/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NewUserProfile : NSObject, NSCoding, Mappable{
    
    var code : Int?
    var pendingReviews : [NewPendingReview]?
    var transactions : [NewTransaction]?
    var msg:String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return NewUserProfile()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        code <- map["code"]
        pendingReviews <- map["pendingReviews"]
        transactions <- map["transactions"]
        msg <- map["msg"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        pendingReviews = aDecoder.decodeObject(forKey: "pendingReviews") as? [NewPendingReview]
        transactions = aDecoder.decodeObject(forKey: "transactions") as? [NewTransaction]
        
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if pendingReviews != nil{
            aCoder.encode(pendingReviews, forKey: "pendingReviews")
        }
        if transactions != nil{
            aCoder.encode(transactions, forKey: "transactions")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        
    }
    
}
