//
//  User.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import CoreData

public extension CodingUserInfoKey {
    static let managedObjectContext = CodingUserInfoKey(rawValue: "managedContextObject")
}

class User: NSManagedObject, Decodable {
    
    @NSManaged var login: String?
    @NSManaged var id: Int16
    @NSManaged var avatarURL: String?
    @NSManaged var type: String?
    @NSManaged var siteAdmin: Bool
    @NSManaged var isNotesAdded: Bool
    @NSManaged var isSeen: Bool
    
    enum CodingKeys: String, CodingKey {
        case login
        case id
        case avatarURL = "avatar_url"
        case type
        case siteAdmin = "site_admin"
    }
    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "User", in: managedObjectContext) else {

            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try container.decodeIfPresent(String.self, forKey: .login)
        let ID = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        self.id = Int16(ID)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.siteAdmin = try container.decodeIfPresent(Bool.self, forKey: .siteAdmin) ?? false
    }
        
}
