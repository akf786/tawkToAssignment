//
//  UserProfileCoordinator.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit
import CoreData

class UserProfileCoordinator: Coordinator {
    
    private var navigationController: UINavigationController!
    private var dataStore: DataStore
    private var container: NSPersistentContainer
    private var user: User
    
    
    //MARK: - Initializer
    init(navigationController: UINavigationController, dataStore: DataStore, user: User, persistentContainer: NSPersistentContainer) {
        self.navigationController = navigationController
        self.dataStore = dataStore
        self.user = user
        self.container = persistentContainer
        
    }
    
    func start() -> UIViewController {
        if let userProfileVC = UserProfileCoordinator.instantiateViewController() as? UserProfileViewController {
            
            let service = UsersServiceImp(dataStore: self.dataStore, persistentContainer: self.container)
            let viewModel = UserProfileViewModelImpl(user: self.user, service: service)
            //viewModel.coordinatorDelegate = self
            userProfileVC.viewModel = viewModel
            return userProfileVC
        }
        
        return UIViewController()
    }
    
}


//MARK: - StoryboardInitializable
extension UserProfileCoordinator: StoryboardInitializable {
    
    static var storyboardName: UIStoryboard.Storyboard {
        return .main
    }
    
}
