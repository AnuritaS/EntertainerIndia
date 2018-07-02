//
//	NewPendingReview.swift
//
//	Create by Nikhil Bansal on 4/3/2018
//	Copyright © 2018. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class NewPendingReview : NSObject, NSCoding, Mappable{

	var v : Int?
	var id : String?
	var client : NewClient?
	var status : String?
	var transactionId : String?
	var user : String?


	class func newInstance(map: Map) -> Mappable?{
		return NewPendingReview()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		v <- map["__v"]
		id <- map["_id"]
		client <- map["client"]
		status <- map["status"]
		transactionId <- map["transaction_id"]
		user <- map["user"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         v = aDecoder.decodeObject(forKey: "__v") as? Int
         id = aDecoder.decodeObject(forKey: "_id") as? String
         client = aDecoder.decodeObject(forKey: "client") as? NewClient
         status = aDecoder.decodeObject(forKey: "status") as? String
         transactionId = aDecoder.decodeObject(forKey: "transaction_id") as? String
         user = aDecoder.decodeObject(forKey: "user") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if v != nil{
			aCoder.encode(v, forKey: "__v")
		}
		if id != nil{
			aCoder.encode(id, forKey: "_id")
		}
		if client != nil{
			aCoder.encode(client, forKey: "client")
		}
		if status != nil{
			aCoder.encode(status, forKey: "status")
		}
		if transactionId != nil{
			aCoder.encode(transactionId, forKey: "transaction_id")
		}
		if user != nil{
			aCoder.encode(user, forKey: "user")
		}

	}

}