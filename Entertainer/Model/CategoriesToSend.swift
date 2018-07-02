//
//	CategoriesToSend.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class CategoriesToSend : NSObject, NSCoding, Mappable{

	var category : String?
	var subCategories : [String]?


	class func newInstance(map: Map) -> Mappable?{
		return CategoriesToSend()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		category <- map["category"]
		subCategories <- map["sub_categories"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         category = aDecoder.decodeObject(forKey: "category") as? String
         subCategories = aDecoder.decodeObject(forKey: "sub_categories") as? [String]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if category != nil{
			aCoder.encode(category, forKey: "category")
		}
		if subCategories != nil{
			aCoder.encode(subCategories, forKey: "sub_categories")
		}

	}

}