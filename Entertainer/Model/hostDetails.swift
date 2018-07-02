//
//    hostDetails.swift
//  Created by Anurita Srivastava on 19/02/18.


import Foundation
import ObjectMapper


class hostDetails : NSObject, NSCoding, Mappable{
    
    var client : Client?
    var code : Int?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return hostDetails()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        client <- map["client"]
        code <- map["code"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        client = aDecoder.decodeObject(forKey: "client") as? Client
        code = aDecoder.decodeObject(forKey: "code") as? Int
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if client != nil{
            aCoder.encode(client, forKey: "client")
        }
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        
    }
    
}
