//
//	authToken.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class accessToken : NSObject, NSCoding, Mappable{
    
    var accessLevel : String?
    var authToken : String?
    var code : Int?
    var refToken : String?
    var userId : String?
    var contact : Int?
    var msg:String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return accessToken()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        accessLevel <- map["access_level"]
        authToken <- map["authToken"]
        code <- map["code"]
        refToken <- map["refToken"]
        userId <- map["userId"]
        contact <- map["contact"]
        msg <- map["msg"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        accessLevel = aDecoder.decodeObject(forKey: "access_level") as? String
        authToken = aDecoder.decodeObject(forKey: "authToken") as? String
        code = aDecoder.decodeObject(forKey: "code") as? Int
        refToken = aDecoder.decodeObject(forKey: "refToken") as? String
        userId = aDecoder.decodeObject(forKey: "userId") as? String
        contact = aDecoder.decodeObject(forKey: "contact") as? Int
        msg = aDecoder.decodeObject(forKey: "msg") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if accessLevel != nil{
            aCoder.encode(accessLevel, forKey: "access_level")
        }
        if authToken != nil{
            aCoder.encode(authToken, forKey: "authToken")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if refToken != nil{
            aCoder.encode(refToken, forKey: "refToken")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if contact != nil{
            aCoder.encode(contact, forKey: "contact")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        
    }
    
}
