//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by Chan on 6/2/24.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var accessToken: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var refreshToken: String?

}
