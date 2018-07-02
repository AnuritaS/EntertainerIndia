//
//    Client.swift
//    Copyright © 2018. All rights reserved.
//Created by Anurita Srivastava on 20/12/17.

import Foundation
import ObjectMapper


class Client : NSObject, NSCoding, Mappable{
    
    var v : Int?
    var id : String?
    var accessLevel : String?
    var branches : [Branche]?
    var category : String?
    var contact : String?
    var coupons : [String]?
    var createdAt : String?
    var descriptionField : String?
    var email : String?
    var establishmentName : String?
    var imgUrl : [String]?
    var inCollection : Int?
    var loginAttempts : Int?
    var logo : String?
    var loyaltyRewards : [AnyObject]?
    var rating : Int?
    var recommended : Bool?
    var socialMedia : SocialMedia?
    var subCategories : [String]?
    var updatedAt : String?
    
    
    class func newInstance(map: Map) -> Mappable?{
        return Client()
    }
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        v <- map["__v"]
        id <- map["_id"]
        accessLevel <- map["access_level"]
        branches <- map["branches"]
        category <- map["category"]
        contact <- map["contact"]
        coupons <- map["coupons"]
        createdAt <- map["createdAt"]
        descriptionField <- map["description"]
        email <- map["email"]
        establishmentName <- map["establishment_name"]
        imgUrl <- map["imgUrl"]
        inCollection <- map["in_collection"]
        loginAttempts <- map["login_attempts"]
        logo <- map["logo"]
        loyaltyRewards <- map["loyalty_rewards"]
        rating <- map["rating"]
        recommended <- map["recommended"]
        socialMedia <- map["social_media"]
        subCategories <- map["sub_categories"]
        updatedAt <- map["updatedAt"]
        
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        v = aDecoder.decodeObject(forKey: "__v") as? Int
        id = aDecoder.decodeObject(forKey: "_id") as? String
        accessLevel = aDecoder.decodeObject(forKey: "access_level") as? String
        branches = aDecoder.decodeObject(forKey: "branches") as? [Branche]
        category = aDecoder.decodeObject(forKey: "category") as? String
        contact = aDecoder.decodeObject(forKey: "contact") as? String
        coupons = aDecoder.decodeObject(forKey: "coupons") as? [String]
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        establishmentName = aDecoder.decodeObject(forKey: "establishment_name") as? String
        imgUrl = aDecoder.decodeObject(forKey: "imgUrl") as? [String]
        inCollection = aDecoder.decodeObject(forKey: "in_collection") as? Int
        loginAttempts = aDecoder.decodeObject(forKey: "login_attempts") as? Int
        logo = aDecoder.decodeObject(forKey: "logo") as? String
        loyaltyRewards = aDecoder.decodeObject(forKey: "loyalty_rewards") as? [AnyObject]
        rating = aDecoder.decodeObject(forKey: "rating") as? Int
        recommended = aDecoder.decodeObject(forKey: "recommended") as? Bool
        socialMedia = aDecoder.decodeObject(forKey: "social_media") as? SocialMedia
        subCategories = aDecoder.decodeObject(forKey: "sub_categories") as? [String]
        updatedAt = aDecoder.decodeObject(forKey: "updatedAt") as? String
        
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
        if accessLevel != nil{
            aCoder.encode(accessLevel, forKey: "access_level")
        }
        if branches != nil{
            aCoder.encode(branches, forKey: "branches")
        }
        if category != nil{
            aCoder.encode(category, forKey: "category")
        }
        if contact != nil{
            aCoder.encode(contact, forKey: "contact")
        }
        if coupons != nil{
            aCoder.encode(coupons, forKey: "coupons")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "createdAt")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if establishmentName != nil{
            aCoder.encode(establishmentName, forKey: "establishment_name")
        }
        if imgUrl != nil{
            aCoder.encode(imgUrl, forKey: "imgUrl")
        }
        if inCollection != nil{
            aCoder.encode(inCollection, forKey: "in_collection")
        }
        if loginAttempts != nil{
            aCoder.encode(loginAttempts, forKey: "login_attempts")
        }
        if logo != nil{
            aCoder.encode(logo, forKey: "logo")
        }
        if loyaltyRewards != nil{
            aCoder.encode(loyaltyRewards, forKey: "loyalty_rewards")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if recommended != nil{
            aCoder.encode(recommended, forKey: "recommended")
        }
        if socialMedia != nil{
            aCoder.encode(socialMedia, forKey: "social_media")
        }
        if subCategories != nil{
            aCoder.encode(subCategories, forKey: "sub_categories")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updatedAt")
        }
        
    }
    
}
