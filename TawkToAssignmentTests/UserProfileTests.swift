//
//  UserProfileTests.swift
//  TawkToAssignmentTests
//
//  Created by Macbook on 31/05/2022.
//

import XCTest

@testable import TawkToAssignment

class UserProfileTests: XCTestCase {

    func testFetchUsersProfilePositive() {
        let service = UsersServiceImp(dataStore: DataStorePositiveMock(), persistentContainer: myPersistentContainer!)
        
        let viewModel = UserProfileViewModelImpl(user: User(), service: service)
        
        let expectation = XCTestExpectation(description: "response")
        
        viewModel.service.getUserProfile(userName: "mojombo") { result in
            
            switch result {
            case .success(let user):
                XCTAssert(!user!.avatarURL!.isEmpty)
                XCTAssert(user!.name == "Tom Preston-Werner")
                XCTAssert(user!.type == "User")
                
                expectation.fulfill()
            case .failure(_):
                break
            }
            
        }
    }
    
    func testUserProfileNegative() {
        let service = UsersServiceImp(dataStore: DataStoreNegativeMock(), persistentContainer: myPersistentContainer!)
        
        let viewModel = UserProfileViewModelImpl(user: User(), service: service)
        
        let expectation = XCTestExpectation(description: "response")

        viewModel.service.getUserProfile(userName: "adshask") { result in
            
            switch result {
            case .success(_):
                break
                
                
            case .failure(let error):
                XCTAssert(error.rawValue == "User does not exist")
                expectation.fulfill()
                break
            }
            
        }
    }
    

}
