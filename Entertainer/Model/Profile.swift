//
//	Profile.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class Profile : NSObject, NSCoding, Mappable{

	var contact : Int?
	var couponBank : String?
	var imgUrl : String?
    var email : String?
    var gender : String?
    var dob : String?


	class func newInstance(map: Map) -> Mappable?{
		return Profile()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		contact <- map["contact"]
		couponBank <- map["coupon_bank"]
        imgUrl <- map["imgUrl"]
        email <- map["email"]
        dob <- map["dob"]
        gender <- map["gender"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         contact = aDecoder.decodeObject(forKey: "contact") as? Int
         couponBank = aDecoder.decodeObject(forKey: "coupon_bank") as? String
        imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        gender = aDecoder.decodeObject(forKey: "gender") as? String
        dob = aDecoder.decodeObject(forKey: "dob") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if contact != nil{
			aCoder.encode(contact, forKey: "contact")
		}
		if couponBank != nil{
			aCoder.encode(couponBank, forKey: "coupon_bank")
		}
        if imgUrl != nil{
            aCoder.encode(imgUrl, forKey: "imgUrl")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if gender != nil{
            aCoder.encode(gender, forKey: "gender")
        }
        if dob != nil{
            aCoder.encode(dob, forKey: "dob")
        }

	}

}
