//
//	ClientPopup.swift
//  Created by Anurita Srivastava on 19/02/18.


import Foundation 
import ObjectMapper


class ClientPopup : NSObject, NSCoding, Mappable{

	var id : String?
	var branches : [Branche]?
	var coupons : [String]?
	var establishmentName : String?
	var imgUrl : [String]?
	var rating : Float?
	var subCategories : [String]?


	class func newInstance(map: Map) -> Mappable?{
		return ClientPopup()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["_id"]
		branches <- map["branches"]
		coupons <- map["coupons"]
		establishmentName <- map["establishment_name"]
		imgUrl <- map["imgUrl"]
		rating <- map["rating"]
		subCategories <- map["sub_categories"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         branches = aDecoder.decodeObject(forKey: "branches") as? [Branche]
         coupons = aDecoder.decodeObject(forKey: "coupons") as? [String]
         establishmentName = aDecoder.decodeObject(forKey: "establishment_name") as? String
         imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? [String]
         rating = aDecoder.decodeObject(forKey: "rating") as? Float
         subCategories = aDecoder.decodeObject(forKey: "sub_categories") as? [String]

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
		if branches != nil{
			aCoder.encode(branches, forKey: "branches")
		}
		if coupons != nil{
			aCoder.encode(coupons, forKey: "coupons")
		}
		if establishmentName != nil{
			aCoder.encode(establishmentName, forKey: "establishment_name")
		}
		if imgUrl != nil{
			aCoder.encode(imgUrl, forKey: "imgUrl")
		}
		if rating != nil{
			aCoder.encode(rating, forKey: "rating")
		}
		if subCategories != nil{
			aCoder.encode(subCategories, forKey: "sub_categories")
		}

	}

}
