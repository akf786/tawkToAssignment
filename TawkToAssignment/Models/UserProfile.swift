//
//  UserProfile.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import CoreData

class UserProfile: NSManagedObject, Decodable {
    
    @NSManaged var login: String?
    @NSManaged var id: Int16
    @NSManaged var avatarURL: String?
    @NSManaged var type: String?
    @NSManaged var siteAdmin: Bool
    @NSManaged var name: String?
    @NSManaged var publicRepos, followers, following: Int16
    @NSManaged var notes: String?
    
    enum CodingKeys: String, CodingKey {
        case login, id
        case avatarURL = "avatar_url"
        case type
        case siteAdmin = "site_admin"
        case name
        case publicRepos = "public_repos"
        case followers, following
    }

    
    required convenience init(from decoder: Decoder) throws {
        guard let codingUserInfoKeyManagedObjectContext = CodingUserInfoKey.managedObjectContext,
              let managedObjectContext = decoder.userInfo[codingUserInfoKeyManagedObjectContext] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: managedObjectContext) else {

            fatalError("Failed to decode User")
        }
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.login = try container.decodeIfPresent(String.self, forKey: .login)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.avatarURL = try container.decodeIfPresent(String.self, forKey: .avatarURL)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
        self.siteAdmin = try container.decodeIfPresent(Bool.self, forKey: .siteAdmin) ?? false
        
        let ID = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        let reposCount = try container.decodeIfPresent(Int.self, forKey: .publicRepos) ?? 0
        let followersCount = try container.decodeIfPresent(Int.self, forKey: .followers) ?? 0
        let followingCount = try container.decodeIfPresent(Int.self, forKey: .following) ?? 0
        
        self.id = Int16(ID)
        self.publicRepos = Int16(reposCount)
        self.followers = Int16(followersCount)
        self.following = Int16(followingCount)
    }
    
}
