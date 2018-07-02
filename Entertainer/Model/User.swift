//
//	User.swift
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation 
import ObjectMapper


class User : NSObject, NSCoding, Mappable{

	var categoriesToSend : [CategoriesToSend]?
	var code : Int?
	var partners : Int?
	var results : [[Result]]?
	var subCategories : [SubCategory]?
    var msg:String?


	class func newInstance(map: Map) -> Mappable?{
		return User()
	}
	required init?(map: Map){}
	private override init(){}

	func mapping(map: Map)
	{
		categoriesToSend <- map["categoriesToSend"]
		code <- map["code"]
		partners <- map["partners"]
		results <- map["results"]
		subCategories <- map["sub_categories"]
        msg <- map["msg"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         categoriesToSend = aDecoder.decodeObject(forKey: "categoriesToSend") as? [CategoriesToSend]
         code = aDecoder.decodeObject(forKey: "code") as? Int
         partners = aDecoder.decodeObject(forKey: "partners") as? Int
         results = aDecoder.decodeObject(forKey: "results") as? [[Result]]
         subCategories = aDecoder.decodeObject(forKey: "sub_categories") as? [SubCategory]
        msg = aDecoder.decodeObject(forKey: "msg") as? String

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if categoriesToSend != nil{
			aCoder.encode(categoriesToSend, forKey: "categoriesToSend")
		}
		if code != nil{
			aCoder.encode(code, forKey: "code")
		}
		if partners != nil{
			aCoder.encode(partners, forKey: "partners")
		}
		if results != nil{
			aCoder.encode(results, forKey: "results")
		}
		if subCategories != nil{
			aCoder.encode(subCategories, forKey: "sub_categories")
		}
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }

	}

}
