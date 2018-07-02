//
//    NewTransaction.swift
//
//    Create by Nikhil Bansal on 4/3/2018
//    Copyright © 2018. All rights reserved.
//    Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import ObjectMapper


class NewTransaction : NSObject, NSCoding, Mappable{
    
    var v : Int?
    var id : String?
    var client : NewClient?
    var coupon : String?
    var createdAt : String?
    var transactionType : String?
    var updatedAt : String?
    var user : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return NewTransaction()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        v <- map["__v"]
        id <- map["_id"]
        client <- map["client"]
        coupon <- map["coupon"]
        createdAt <- map["createdAt"]
        transactionType <- map["transaction_type"]
        updatedAt <- map["updatedAt"]
        user <- map["user"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        v = aDecoder.decodeObject(forKey: "__v") as? Int
        id = aDecoder.decodeObject(forKey: "_id") as? String
        client = aDecoder.decodeObject(forKey: "client") as? NewClient
        coupon = aDecoder.decodeObject(forKey: "coupon") as? String
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        transactionType = aDecoder.decodeObject(forKey: "transaction_type") as? String
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        user = aDecoder.decodeObject(forKey: "user") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if v != nil{
            aCoder.encode(v, forKey: "__v")
        }
        if id != nil{
            aCoder.encode(id, forKey: "_id")
        }
        if client != nil{
            aCoder.encode(client, forKey: "client")
        }
        if coupon != nil{
            aCoder.encode(coupon, forKey: "coupon")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if transactionType != nil{
            aCoder.encode(transactionType, forKey: "transaction_type")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        if user != nil{
            aCoder.encode(user, forKey: "user")
        }
        
    }
    
}

