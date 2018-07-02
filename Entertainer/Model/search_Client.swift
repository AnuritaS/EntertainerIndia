//
//	search_Client.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class search_Client : NSObject, NSCoding, Mappable{
    
    var categoriesToSend : [CategoriesToSend]?
    var clients : [Client]?
    var code : Int?
    var count : Int?
    var msg:String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return search_Client()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        categoriesToSend <- map["categoriesToSend"]
        clients <- map["clients"]
        code <- map["code"]
        count <- map["count"]
        msg <- map["msg"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        categoriesToSend = aDecoder.decodeObject(forKey: "categoriesToSend") as? [CategoriesToSend]
        clients = aDecoder.decodeObject(forKey: "clients") as? [Client]
        code = aDecoder.decodeObject(forKey: "code") as? Int
        count = aDecoder.decodeObject(forKey: "count") as? Int
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoriesToSend != nil{
            aCoder.encode(categoriesToSend, forKey: "categoriesToSend")
        }
        if clients != nil{
            aCoder.encode(clients, forKey: "clients")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if count != nil{
            aCoder.encode(count, forKey: "count")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        
    }
    
}
