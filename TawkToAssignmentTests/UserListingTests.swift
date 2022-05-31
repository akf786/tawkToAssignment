//
//  UserListingTests.swift
//  TawkToAssignmentTests
//
//  Created by Macbook on 31/05/2022.
//

import Foundation
import XCTest

@testable import TawkToAssignment
class UserListingTests: XCTestCase {

    
    func testFetchUsersListPositive() {
        let service = UsersServiceImp(dataStore: DataStorePositiveMock(), persistentContainer: myPersistentContainer!)
        let viewModel = UsersListViewModelImp(users: [], service: service)
        
        let expectation = XCTestExpectation(description: "response")

        viewModel.service.getUsersList(since: 0) { result in
            
            switch result {
            case .success(let users):
                XCTAssert(users.count != 0)
                XCTAssert(users.first!.login == "mojombo")
                XCTAssert(!users.first!.siteAdmin)
                
                expectation.fulfill()
            case .failure(_):
                break
            }
            
        }
    }
    
    func testFetchUsersListNegative() {
        let service = UsersServiceImp(dataStore: DataStoreNegativeMock(), persistentContainer: myPersistentContainer!)
        let viewModel = UsersListViewModelImp(users: [], service: service)
        
        let expectation = XCTestExpectation(description: "response")

        viewModel.service.getUsersList(since: 0) { result in
            
            switch result {
            case .success(_):
                break
                
                
            case .failure(let error):
                XCTAssert(error.rawValue == "Parsing error")
                expectation.fulfill()
            }
            
        }
    }
    

}
