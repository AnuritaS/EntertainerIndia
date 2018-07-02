//
//	UserProfile.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class UserProfile : NSObject, NSCoding, Mappable{

	var code : Int?
	var user : User?
    var msg:String?


	class func newInstance(map: Map) -> Mappable?{
		return UserProfile()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		code <- map["code"]
		user <- map["user"]
        msg <- map["msg"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         code = aDecoder.decodeObject(forKey: "code") as? Int
         user = aDecoder.decodeObject(forKey: "user") as? User
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
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }

	}

}
