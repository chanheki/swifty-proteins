//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Chan on 6/12/24.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?

}
