//
//  AppCoordinator.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit
import CoreData

protocol Coordinator {
    func start() -> UIViewController
}

final class AppCoordinator: Coordinator {
    
    lazy var dataStore : DataStore = {
        return DataStoreImp()
    }()
    
    private var window : UIWindow?

    var userListCoordinator: UserListCoordinator?
    var persistentContainer: NSPersistentContainer

    //MARK: - Initializer
    init(window : UIWindow?, container: NSPersistentContainer ) {
        self.window = window
        self.persistentContainer = container
    }
    
    
    @discardableResult
    func start() -> UIViewController {
        userListCoordinator = UserListCoordinator(dataStore: self.dataStore, container: self.persistentContainer)
        let mainVC = userListCoordinator?.start()
        self.window?.rootViewController = mainVC
        self.window?.makeKeyAndVisible()
        return UIViewController()
    }
}
