//
//	SocialMedia.swift
//
//	
//	Copyright © 2018. All rights reserved.
//	Created by Anurita Srivastava on 20/12/17.

import Foundation 
import ObjectMapper


class SocialMedia : NSObject, NSCoding, Mappable{

	var facebook : String?
	var instagram : String?
	var snapchat : String?
	var twitter : String?
	var youtube : String?


	class func newInstance(map: Map) -> Mappable?{
		return SocialMedia()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		facebook <- map["facebook"]
		instagram <- map["instagram"]
		snapchat <- map["snapchat"]
		twitter <- map["twitter"]
		youtube <- map["youtube"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         facebook = aDecoder.decodeObject(forKey: "facebook") as? String
         instagram = aDecoder.decodeObject(forKey: "instagram") as? String
         snapchat = aDecoder.decodeObject(forKey: "snapchat") as? String
         twitter = aDecoder.decodeObject(forKey: "twitter") as? String
         youtube = aDecoder.decodeObject(forKey: "youtube") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if facebook != nil{
			aCoder.encode(facebook, forKey: "facebook")
		}
		if instagram != nil{
			aCoder.encode(instagram, forKey: "instagram")
		}
		if snapchat != nil{
			aCoder.encode(snapchat, forKey: "snapchat")
		}
		if twitter != nil{
			aCoder.encode(twitter, forKey: "twitter")
		}
		if youtube != nil{
			aCoder.encode(youtube, forKey: "youtube")
		}

	}

}
