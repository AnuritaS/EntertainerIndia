//
//	Branche.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class Branche : NSObject, NSCoding, Mappable{

	var id : String?
	var address : String?
	var location : [Float]?
	var timing : Timing?


	class func newInstance(map: Map) -> Mappable?{
		return Branche()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		id <- map["_id"]
		address <- map["address"]
		location <- map["location"]
		timing <- map["timing"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         id = aDecoder.decodeObject(forKey: "_id") as? String
         address = aDecoder.decodeObject(forKey: "address") as? String
         location = aDecoder.decodeObject(forKey: "location") as? [Float]
         timing = aDecoder.decodeObject(forKey: "timing") as? Timing

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
		if address != nil{
			aCoder.encode(address, forKey: "address")
		}
		if location != nil{
			aCoder.encode(location, forKey: "location")
		}
		if timing != nil{
			aCoder.encode(timing, forKey: "timing")
		}

	}

}