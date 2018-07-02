//
//	ClientOfferResult.swift
//
//	Create by Nikhil Bansal on 5/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class ClientOfferResult : NSObject, NSCoding, Mappable{

	var tnC : String?
	var v : Int?
	var id : String?
	var category : String?
	var city : String?
	var client : String?
	var createdAt : String?
	var descriptionField : String?
	var details : String?
	var expiry : String?
	var group : String?
	var imgUrl : String?
	var isUsed : Bool?
	var priority : Int?
	var recommended : Bool?
	var sold : Int?
	var subCategory : String?
	var type : String?
	var updatedAt : String?


	class func newInstance(map: Map) -> Mappable?{
		return ClientOfferResult()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		tnC <- map["TnC"]
		v <- map["__v"]
		id <- map["_id"]
		category <- map["category"]
		city <- map["city"]
		client <- map["client"]
		createdAt <- map["createdAt"]
		descriptionField <- map["description"]
		details <- map["details"]
		expiry <- map["expiry"]
		group <- map["group"]
		imgUrl <- map["imgUrl"]
		isUsed <- map["is_used"]
		priority <- map["priority"]
		recommended <- map["recommended"]
		sold <- map["sold"]
		subCategory <- map["sub_category"]
		type <- map["type"]
		updatedAt <- map["updatedAt"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         tnC = aDecoder.decodeObject(forKey: "TnC") as? String
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         category = aDecoder.decodeObject(forKey: "category") as? String
         city = aDecoder.decodeObject(forKey: "city") as? String
         client = aDecoder.decodeObject(forKey: "client") as? String
         createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
         descriptionField = aDecoder.decodeObject(forKey: "description") as? String
         details = aDecoder.decodeObject(forKey: "details") as? String
         expiry = aDecoder.decodeObject(forKey: "expiry") as? String
         group = aDecoder.decodeObject(forKey: "group") as? String
         imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? String
         isUsed = aDecoder.decodeObject(forKey: "is_used") as? Bool
         priority = aDecoder.decodeObject(forKey: "priority") as? Int
         recommended = aDecoder.decodeObject(forKey: "recommended") as? Bool
         sold = aDecoder.decodeObject(forKey: "sold") as? Int
         subCategory = aDecoder.decodeObject(forKey: "sub_category") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if tnC != nil{
			aCoder.encode(tnC, forKey: "TnC")
		}
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if city != nil{
			aCoder.encode(city, forKey: "city")
		}
		if client != nil{
			aCoder.encode(client, forKey: "client")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "createdAt")
		}
		if descriptionField != nil{
			aCoder.encode(descriptionField, forKey: "description")
		}
		if details != nil{
			aCoder.encode(details, forKey: "details")
		}
		if expiry != nil{
			aCoder.encode(expiry, forKey: "expiry")
		}
		if group != nil{
			aCoder.encode(group, forKey: "group")
		}
		if imgUrl != nil{
			aCoder.encode(imgUrl, forKey: "imgUrl")
		}
		if isUsed != nil{
			aCoder.encode(isUsed, forKey: "is_used")
		}
		if priority != nil{
			aCoder.encode(priority, forKey: "priority")
		}
		if recommended != nil{
			aCoder.encode(recommended, forKey: "recommended")
		}
		if sold != nil{
			aCoder.encode(sold, forKey: "sold")
		}
		if subCategory != nil{
			aCoder.encode(subCategory, forKey: "sub_category")
		}
		if type != nil{
			aCoder.encode(type, forKey: "type")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updatedAt")
		}

	}

}