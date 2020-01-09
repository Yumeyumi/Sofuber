//
//  UserCoreData+CoreDataProperties.swift
//  
//
//  Created by Beatriz Lopez Del Moral Garcia Jimenez on 9/1/20.
//
//

import Foundation
import CoreData


extension UserCoreData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserCoreData> {
        return NSFetchRequest<UserCoreData>(entityName: "UserCoreData")
    }

    @NSManaged public var user: String?
    @NSManaged public var pass: String?

}
