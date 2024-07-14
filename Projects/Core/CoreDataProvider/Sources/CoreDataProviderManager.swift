//
//  ProteinsViewController.swift
//  FeatureProteins
//
//  Created by Chan on 4/3/24.
//

import CoreData

import CoreCoreDataProviderInterface

public final class CoreDataProvider: CoreDataProviderInterface {
    
    public static let shared = CoreDataProvider()
    public init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        // 모듈 번들을 가져옴
        let bundle = Bundle(for: CoreDataProvider.self)
        // 리소스 번들의 URL을 가져옴
        guard let resourceBundleURL = bundle.url(forResource: "CoreCoreDataProvider_CoreCoreDataProvider", withExtension: "bundle"),
              let resourceBundle = Bundle(url: resourceBundleURL) else {
            fatalError("Failed to locate resource bundle")
        }
        // 번들에서 모델 파일의 URL을 가져옴
        guard let modelURL = resourceBundle.url(forResource: "UserModel", withExtension: "momd") else {
            fatalError("Failed to find model file in resource bundle")
        }
        
        // 모델 파일을 로드함
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to load model file")
        }
        
        let container = NSPersistentContainer(name: "UserModel", managedObjectModel: managedObjectModel)
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        return container
    }()
    
    public func fetchAllUsers() -> [UserEntity] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()

        do {
            let users = try context.fetch(fetchRequest)
            return users
        } catch {
            print("Failed to fetch users: \(error)")
            return []
        }
    }
    
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
    
    public func fetchUserID() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities.first?.id
        } catch {
            print("Error fetching user entity: \(error)")
            return nil
        }
    }
    
    public func fetchUserName() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities.first?.name
        } catch {
            print("Error fetching user entity: \(error)")
            return nil
        }
    }
    
    public func fetchUserPassword() -> String? {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try context.fetch(fetchRequest)
            return userEntities.first?.password
        } catch {
            print("Error fetching user entity: \(error)")
            return nil
        }
    }
    
    public func isRightPassword(password : String) -> Bool {
        let userContext = persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        
        do {
            let userEntities = try userContext.fetch(fetchRequest)
            return !userEntities.isEmpty && userEntities.first?.password == password
        } catch {
            print("Error fetching user token: \(error)")
            return false
        }
    }
    
    public func clearCoreData() {
        let context = persistentContainer.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
            let userEntities = try context.fetch(fetchRequest)
            
            for userEntity in userEntities {
                context.delete(userEntity)
            }
            
            try context.save()
            print("CoreData successfully cleared")
        } catch {
            print("Error clearing CoreData: \(error)")
        }
    }

    
    public func createUser(id: String, name: String) -> Bool {
        let context = persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.insertNewObject(forEntityName: "UserEntity", into: context) as? UserEntity {
            userEntity.id = id
            userEntity.name = name
            
            do {
                try context.save()

                if let url = persistentContainer.persistentStoreCoordinator.persistentStores.first?.url {
                    print("Database Path: \(url.path)")
                }

                print("New user created and saved.")
                return true
            } catch {
                print("Failed to create new user: \(error)")
                return false
            }
        } else {
            print("Failed to create UserEntity object")
            return false
        }
    }
    
    public func updatePasswordForCurrentUser(password: String) -> Bool {
        guard let userId = AppStateManager.shared.userID else {
            print("No user ID available.")
            return false
        }

        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userId)

        do {
            if let userEntity = try context.fetch(fetchRequest).first {
                userEntity.password = password
                try context.save()
                print("Password updated and saved to CoreData for user ID: \(userId)")
                return true
            } else {
                print("No user found with ID \(userId) to update password.")
                return false
            }
        } catch {
            print("Error fetching user or saving password: \(error.localizedDescription)")
            return false
        }
    }

}
