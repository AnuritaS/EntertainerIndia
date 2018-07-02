//
//	Premium.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class Premium : NSObject, NSCoding, Mappable{

	var status : Bool?


	class func newInstance(map: Map) -> Mappable?{
		return Premium()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		status <- map["status"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         status = aDecoder.decodeObject(forKey: "status") as? Bool

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}

	}

}
