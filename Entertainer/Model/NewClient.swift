//
//	NewClient.swift
//
//	Create by Nikhil Bansal on 4/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NewClient : NSObject, NSCoding, Mappable{

	var id : String?
	var establishmentName : String?
	var logo : String?


	class func newInstance(map: Map) -> Mappable?{
		return NewClient()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["_id"]
		establishmentName <- map["establishment_name"]
		logo <- map["logo"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         establishmentName = aDecoder.decodeObject(forKey: "establishment_name") as? String
         logo = aDecoder.decodeObject(forKey: "logo") as? String

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
		if establishmentName != nil{
			aCoder.encode(establishmentName, forKey: "establishment_name")
		}
		if logo != nil{
			aCoder.encode(logo, forKey: "logo")
		}

	}

}