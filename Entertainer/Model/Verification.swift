//
//	Verification.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class Verification : NSObject, NSCoding, Mappable{

	var email : Bool?
	var mobile : Bool?


	class func newInstance(map: Map) -> Mappable?{
		return Verification()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		email <- map["email"]
		mobile <- map["mobile"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         email = aDecoder.decodeObject(forKey: "email") as? Bool
         mobile = aDecoder.decodeObject(forKey: "mobile") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if email != nil{
			aCoder.encode(email, forKey: "email")
		}
		if mobile != nil{
			aCoder.encode(mobile, forKey: "mobile")
		}

	}

}
