//
//	Timing.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Timing : NSObject, NSCoding, Mappable{

	var weekdays : Weekday?
	var weekends : Weekday?


	class func newInstance(map: Map) -> Mappable?{
		return Timing()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		weekdays <- map["weekdays"]
		weekends <- map["weekends"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         weekdays = aDecoder.decodeObject(forKey: "weekdays") as? Weekday
         weekends = aDecoder.decodeObject(forKey: "weekends") as? Weekday

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if weekdays != nil{
			aCoder.encode(weekdays, forKey: "weekdays")
		}
		if weekends != nil{
			aCoder.encode(weekends, forKey: "weekends")
		}

	}

}