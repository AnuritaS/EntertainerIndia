//
//	accessTokenLogin.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class accessTokenLogin : NSObject, NSCoding, Mappable{

	var accessLevel : String?
	var authToken : String?
	var code : Int?
    var msg:String?
    var name:String?
	var profile : Profile?
	var refToken : String?
	var userId : String?
    var contact : Int?


	class func newInstance(map: Map) -> Mappable?{
		return accessTokenLogin()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		accessLevel <- map["access_level"]
		authToken <- map["authToken"]
		code <- map["code"]
		profile <- map["profile"]
		refToken <- map["refToken"]
		userId <- map["userId"]
        contact <- map["contact"]
        msg <- map["msg"]
        name <- map["name"]
		
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
         profile = aDecoder.decodeObject(forKey: "profile") as? Profile
         refToken = aDecoder.decodeObject(forKey: "refToken") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? String
         contact = aDecoder.decodeObject(forKey: "contact") as? Int
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
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
		if profile != nil{
			aCoder.encode(profile, forKey: "profile")
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
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        

	}

}
