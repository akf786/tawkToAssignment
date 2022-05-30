//
//  UserListCoordinator.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit
import CoreData

class UserListCoordinator: Coordinator {
    
    private var rootViewController: UINavigationController!
    private var container : NSPersistentContainer
    private var dataStore : DataStore
    
    
    //MARK: - Initializer
    init( dataStore : DataStore, container: NSPersistentContainer) {
        self.dataStore = dataStore
        self.container = container
    }
    
    func start() -> UIViewController {
        if let usersListVC = UserListCoordinator.instantiateViewController() as? UsersListViewController {
            rootViewController = BaseNavigationController(rootViewController: usersListVC)
            
            let service = UsersServiceImp(dataStore: self.dataStore, persistentContainer: container)
            let viewModel = UsersListViewModelImp(users: [], service: service)
            viewModel.coordinatorDelegate = self
            usersListVC.viewModel = viewModel
            return rootViewController
        }
        
        return UIViewController()
    }
}


//MARK: - TvShowsList Coordinator Delegate
extension UserListCoordinator : UsersListViewModelCoordinatorDelegate{
    
    /// This function called when user tapped on add new tv show button on listing screen
    func didTapOnUser(user: User, delegate: UsersListViewModelImp) {
        
        let userProfileCoordinator = UserProfileCoordinator(navigationController: self.rootViewController,
                                                    dataStore: self.dataStore,
                                                    user: user,
                                                    persistentContainer: self.container)
        if let userProfileVC = userProfileCoordinator.start() as? UserProfileViewController {
            self.rootViewController.pushViewController(userProfileVC, animated: true)
        }
    }
    
}


//MARK: - StoryboardInitializable
extension UserListCoordinator: StoryboardInitializable {
    
    static var storyboardName: UIStoryboard.Storyboard {
        return .main
    }
    
}
