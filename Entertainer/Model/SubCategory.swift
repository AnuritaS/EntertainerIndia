//
//	SubCategory.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class SubCategory : NSObject, NSCoding, Mappable{

	var category : String?
	var subCategory : String?


	class func newInstance(map: Map) -> Mappable?{
		return SubCategory()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		category <- map["category"]
		subCategory <- map["sub_category"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         category = aDecoder.decodeObject(forKey: "category") as? String
         subCategory = aDecoder.decodeObject(forKey: "sub_category") as? String

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
		if subCategory != nil{
			aCoder.encode(subCategory, forKey: "sub_category")
		}

	}

}