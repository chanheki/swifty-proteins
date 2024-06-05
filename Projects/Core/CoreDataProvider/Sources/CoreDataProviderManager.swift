//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import CoreData

import CoreCoreDataProviderInterface

public final class CoreDataProvider {

    public static let shared = CoreDataProvider()
    public init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    public func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func fetchUserEntity() -> [UserEntity]? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities
        } catch {
            print("Error fetching user entity: \(error)")
            return nil
        }
    }
    
    public func createUserEntity(accessToken: String, refreshToken: String) -> Bool {
        let context = persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity {
            userEntity.accessToken = accessToken
            userEntity.refreshToken = refreshToken

            do {
                try context.save()
                print("AccessToken and RefreshToken saved to CoreData")
                return true
            } catch {
                print("Error saving Tokens to CoreData: \(error.localizedDescription)")
                return false
            }
        } else {
            print("Failed to create UserEntity object")
            return false
        }
    }
}
