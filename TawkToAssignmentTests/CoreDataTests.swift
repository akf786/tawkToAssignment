//
//  CoreDataTests.swift
//  TawkToAssignmentTests
//
//  Created by Macbook on 31/05/2022.
//

import Foundation
import CoreData
import XCTest

var myPersistentContainer = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer

@testable import TawkToAssignment
class CoreDataTests: XCTestCase {

    var userServiceMock: UsersServiceImp?


    override func setUp() {
        super.setUp()

        if let container = myPersistentContainer {
            self.userServiceMock = UsersServiceImp(dataStore: DataStoreImp(), persistentContainer: container)
        }
        
    }
    
    func testPersistentContainerNotNil(){
        let instance = self.userServiceMock?.persistentContainer
        XCTAssertNotNil( instance )
    }
    
    func testCreateUserInDB() {
        userServiceMock?.saveUsersInDB(jsonData: onlyUserArrayResponse, completion: { users in
            XCTAssertNotNil(users)
        })
    }
    
    func testsaveUserProfileInDB() {
        userServiceMock?.saveUserProfileInDB(jsonData: userProfileResponse, completion: { profile in
            XCTAssertNotNil(profile)
        })
    }
    
    func testFetchUserProfileFromDB() {
        userServiceMock?.saveUserProfileInDB(jsonData: userProfileResponse, completion: { _ in
            self.userServiceMock?.fetchProfileIfSavedOf(userName: "awais", completionHandler: { profile in
                XCTAssertNotNil(profile)
            })
        })
        
    }
    
    func testFetchCreatedUser() {
        let results = userServiceMock?.fetchLocalUserList(completionHandler: { users in
            XCTAssertNotNil(users)
        })
    }
    
    func testSaveUserNotes() {
        userServiceMock?.saveNotesOf(userName: "awais", withNotes: "test succesffully written", completionHandler: {
            
            self.userServiceMock?.fetchProfileIfSavedOf(userName: "awais", completionHandler: { profile in
                XCTAssert(((profile?.notes) != nil), "test succesffully written")
            })
            
        })
    }
    
}


