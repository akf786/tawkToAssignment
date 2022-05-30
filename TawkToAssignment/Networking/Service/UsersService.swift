//
//  UsersService.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import CoreData

protocol UsersService {
    var dataStore: DataStore { get }
    var persistentContainer: NSPersistentContainer { get }
    
    func getUsersList(since: Int, completionHandler: @escaping (Result<[User], NetworkError>) -> Void)
    func getUserProfile(userName: String, completionHandler: @escaping (Result<UserProfile?, NetworkError>) -> Void)
    
    
    func fetchLocalUserList(completionHandler: @escaping (_ users: [User]?) -> Void)
    func saveUsersInDB(jsonData: Data, completion: @escaping(_ users: [User]?) -> ())
    func saveUserProfileInDB(jsonData: Data, completion: @escaping(_ users: UserProfile?) -> ())
    func fetchProfileIfSavedOf(userName: String, completionHandler: @escaping (UserProfile?) -> Void)
    func saveNotesOf(userName: String, withNotes: String, completionHandler: @escaping () -> Void)
    func setStatusOfNotesAdded(userName: String, notes: String, completionHandler: @escaping () -> Void)
    func setStatusToSeenFor(userName: String, completionHandler: @escaping () -> Void)
}

class UsersServiceImp : UsersService {

    var dataStore: DataStore
    var persistentContainer: NSPersistentContainer
    
    init(dataStore : DataStore, persistentContainer: NSPersistentContainer) {
        self.dataStore = dataStore
        self.persistentContainer = persistentContainer
    }
    
    
    //MARK: - Private Methods
    func getUsersList(since: Int, completionHandler: @escaping (Result<[User], NetworkError>) -> Void) {
        self.dataStore.getUsersList(since: since) { result in
            
            switch result {
                case.success(let data):
                    self.saveUsersInDB(jsonData: data) { users in
                        completionHandler(.success(users ?? []))
                    }
                    
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }

    func getUserProfile(userName: String, completionHandler: @escaping (Result<UserProfile?, NetworkError>) -> Void) {
        self.fetchProfileIfSavedOf(userName: userName) { profile in
            
            if let userProfile = profile {
                completionHandler(.success(userProfile))
            } else {
                self.dataStore.getUserProfile(userName: userName) { result in
                    switch result {
                        case.success(let data):
                            self.saveUserProfileInDB(jsonData: data) { userProfile in
                                completionHandler(.success(userProfile))
                            }
                            
                        case .failure(let error):
                            completionHandler(.failure(error))
                    }
                }
            }
        }
    }
      
    
    //MARK: - Local Database Helper Functions
    func fetchLocalUserList(completionHandler: @escaping ([User]?) -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        do {
            let users = try managedObjectContext.fetch(fetchRequest)
            completionHandler(users)
        } catch _ {
            completionHandler([])
        }
    }
    
    func saveUsersInDB(jsonData: Data, completion: @escaping ([User]?) -> ()) {
        do {
            if let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext {
                let managedObjectContext = persistentContainer.viewContext
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                let users = try decoder.decode([User].self, from: jsonData)
                try managedObjectContext.save()
                completion(users)
            }
            
        } catch let error {
            print(error)
        }
    }
    
    func saveUserProfileInDB(jsonData: Data, completion: @escaping (UserProfile?) -> ()) {
        do {
            if let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext {
                let managedObjectContext = persistentContainer.viewContext
                let decoder = JSONDecoder()
                decoder.userInfo[codingUserInfoKeyManagedObjectContext] = managedObjectContext
                let userProfile = try decoder.decode(UserProfile.self, from: jsonData)
                try managedObjectContext.save()
                completion(userProfile)
            }
            
        } catch let error {
            print(error)
        }
    }
        
    
    func fetchProfileIfSavedOf(userName: String, completionHandler: @escaping (UserProfile?) -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "login LIKE %@", userName)
        do {
            let profile = try managedObjectContext.fetch(fetchRequest).first
            completionHandler(profile)
        } catch _ {
            completionHandler(nil)
        }
    }
    
    func saveNotesOf(userName: String, withNotes: String, completionHandler: @escaping () -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<UserProfile>(entityName: "UserProfile")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "login = %@", userName)
        do {
            let profile = try managedObjectContext.fetch(fetchRequest).first
            profile?.setValue(withNotes, forKey: "notes")
            try managedObjectContext.save()
            completionHandler()
        } catch _ {
            completionHandler()
        }
    }
    
    func setStatusToSeenFor(userName: String, completionHandler: @escaping () -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "login = %@", userName)
        do {
            let profile = try managedObjectContext.fetch(fetchRequest).first
            profile?.setValue(true, forKey: "isSeen")
            try managedObjectContext.save()
            completionHandler()
        } catch _ {
            completionHandler()
        }
    }
    
    func setStatusOfNotesAdded(userName: String, notes: String, completionHandler: @escaping () -> Void) {
        let managedObjectContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.fetchLimit = 1
        fetchRequest.predicate = NSPredicate(format: "login = %@", userName)
        do {
            let profile = try managedObjectContext.fetch(fetchRequest).first
            profile?.setValue(true, forKey: "isNotesAdded")
            profile?.setValue(notes, forKey: "notes")
            try managedObjectContext.save()
            completionHandler()
        } catch _ {
            completionHandler()
        }
    }
    
}
