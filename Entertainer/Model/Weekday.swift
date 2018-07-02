//
//	Weekday.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Weekday : NSObject, NSCoding, Mappable{

	var closing : String?
	var opening : String?


	class func newInstance(map: Map) -> Mappable?{
		return Weekday()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		closing <- map["closing"]
		opening <- map["opening"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         closing = aDecoder.decodeObject(forKey: "closing") as? String
         opening = aDecoder.decodeObject(forKey: "opening") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if closing != nil{
			aCoder.encode(closing, forKey: "closing")
		}
		if opening != nil{
			aCoder.encode(opening, forKey: "opening")
		}

	}

}