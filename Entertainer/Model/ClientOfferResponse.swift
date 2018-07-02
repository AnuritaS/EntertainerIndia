//
//	ClientOfferResponse.swift
//
//	Create by Nikhil Bansal on 5/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ClientOfferResponse : NSObject, NSCoding, Mappable{
    
    var code : Int?
    var result : [ClientOfferResult]?
    var msg : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return ClientOfferResponse()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        code <- map["code"]
        result <- map["result"]
        msg <- map["msg"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        result = aDecoder.decodeObject(forKey: "result") as? [ClientOfferResult]
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
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        
    }
    
}
