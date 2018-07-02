//
//	Notification.swift
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class Notification : NSObject, NSCoding, Mappable{

	var android : [AnyObject]?
	var ios : [AnyObject]?
	var windows : [AnyObject]?


	class func newInstance(map: Map) -> Mappable?{
		return Notification()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		android <- map["android"]
		ios <- map["ios"]
		windows <- map["windows"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         android = aDecoder.decodeObject(forKey: "android") as? [AnyObject]
         ios = aDecoder.decodeObject(forKey: "ios") as? [AnyObject]
         windows = aDecoder.decodeObject(forKey: "windows") as? [AnyObject]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if android != nil{
			aCoder.encode(android, forKey: "android")
		}
		if ios != nil{
			aCoder.encode(ios, forKey: "ios")
		}
		if windows != nil{
			aCoder.encode(windows, forKey: "windows")
		}

	}

}
