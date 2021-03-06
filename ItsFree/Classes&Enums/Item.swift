//
//  Item.swift
//  ItsFree
//
//  Created by Nicholas Fung on 2017-11-16.
//  Copyright © 2017 Sanjay Shah. All rights reserved.
// 

import Foundation
import CoreLocation
import MapKit


class Item: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D {
        get { return self.location }
        set { self.location = newValue }
    }
    var UID:String!
    var name:String
    var itemCategory:ItemCategory
    var itemDescription:String
    var location:CLLocationCoordinate2D
    var posterUID:String
    var quality:ItemQuality
    var tags:Tag
    var photos:[String]
    var value: Int
    
    init(name:String,
         category:ItemCategory,
         description:String,
         location:CLLocationCoordinate2D,
         posterUID:String,
         quality:ItemQuality,
         tags:Tag,
         photos:[String],
         value: Int,
         itemUID:String?) {
        
        self.name = name
        self.itemCategory = category
        self.itemDescription = description
        self.location = location
        self.posterUID = posterUID
        self.quality = quality
        self.tags = tags
        self.posterUID = posterUID
        self.photos = photos
        self.value = value
        
        if itemUID == nil {
            let newItemUID = AppData.sharedInstance.offersNode.childByAutoId()
            self.UID = newItemUID.key
            print("\(self.UID)")
        }
        else {
            self.UID = itemUID
        }

    }
    
    convenience init?(with inpDict:[String:Any]) {
        
        guard
            let inpName: String = inpDict["name"] as? String,
            let inpDescription: String = inpDict["itemDescription"] as? String,
            let inpCategory: String = inpDict["itemCategory"] as? String,
            let inpItemUID: String = inpDict["UID"] as? String,
            let inpPosterUID: String = inpDict["posterID"] as? String,
            let inpQuality: String = inpDict["quality"] as? String,
            let inpTagsArray: [String] =  inpDict["tags"] as? [String],
            let inpLocationDict: [String:Double] = inpDict["location"] as? [String:Double],
        
            let inpValue: Int = (inpDict["value"] as? Int) else
        {
            print("Error: Dictionary is not in the correct format")
            return nil
        }
        
        var inpPhotos: [String]
        
        if let inpPhotosArr: [String] = inpDict["photos"] as? [String] {
            inpPhotos = inpPhotosArr
            
        }
        else {
            print("no photos (might be a request)")
            inpPhotos = []
        }
        
        guard
            let inpLatitude: Double = inpLocationDict["latitude"],
            let inpLongitude: Double = inpLocationDict["longitude"] else
        {
            print("Error: Passed location data is not in the correct format")
            return nil
        }
        
        let inpLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(inpLatitude, inpLongitude)
        let inpTags = Tag()
        inpTags.tagsArray = inpTagsArray
        
        self.init(name: inpName,
                  category: ItemCategory(rawValue: inpCategory)!,
                  description: inpDescription,
                  location: inpLocation,
                  posterUID: inpPosterUID,
                  quality: ItemQuality(rawValue: inpQuality)!,
                  tags: inpTags,
                  photos: inpPhotos,
                  value: inpValue,
                  itemUID:inpItemUID)
    }
    
    func toDictionary() -> [String:Any] {
        let locationDict:[String:Double] = ["latitude":self.location.latitude, "longitude":self.location.longitude]
        
        let itemDict:[String:Any] = [
            "UID": self.UID,
            "name": self.name,
            "itemCategory": self.itemCategory.rawValue,
            "itemDescription": self.itemDescription,
            "location": locationDict,
            "posterID":posterUID,
            "quality":self.quality.rawValue,
            "tags":self.tags.tagsArray,
            "value":self.value,
            "photos":self.photos
            
        ]
        
        return itemDict
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance
    {
        return location.distance(from: CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude))
    }
    
}
