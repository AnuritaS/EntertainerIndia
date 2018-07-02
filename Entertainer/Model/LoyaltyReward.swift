//
//	LoyaltyReward.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class LoyaltyReward : NSObject, NSCoding, Mappable{

	var id : String?
	var colorCode : String?
	var descriptionField : String?
	var details : String?
	var th : String?


	class func newInstance(map: Map) -> Mappable?{
		return LoyaltyReward()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["_id"]
		colorCode <- map["color_code"]
		descriptionField <- map["description"]
		details <- map["details"]
		th <- map["th"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         colorCode = aDecoder.decodeObject(forKey: "color_code") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         details = aDecoder.decodeObject(forKey: "details") as? String
         th = aDecoder.decodeObject(forKey: "th") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if colorCode != nil{
			aCoder.encode(colorCode, forKey: "color_code")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if details != nil{
			aCoder.encode(details, forKey: "details")
		}
		if th != nil{
			aCoder.encode(th, forKey: "th")
		}

	}

}
