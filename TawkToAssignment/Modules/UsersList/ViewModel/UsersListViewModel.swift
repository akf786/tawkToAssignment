//
//  UsersListViewModel.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
typealias UsersListViewModelOutputHandler = (UsersListViewModelOutput) -> ()

protocol UsersListViewModelCoordinatorDelegate : class {
    func didTapOnUser(user: User, delegate: UsersListViewModelImp)
}

protocol UsersListViewModel {
    
    var service : UsersService { get }
    var coordinatorDelegate : UsersListViewModelCoordinatorDelegate? { get set }
    
    var title: String { get }
    var completionHandler: UsersListViewModelOutputHandler? { get set }
    var numberOfRows: Int { get }
    
    func getCellVMAt(index: Int) -> BaseUserListCellViewModel
    func fetchUsers(bottomScrolling: Bool?)
    func searchUser(text: String)
    func tappedAtCell(index: Int)
    func viewDidLoad()
}

enum UsersListViewModelOutput {
    case showLoader
    case hideLoader
    case refreshData
    case showEmptyView
    case hideEmptyView
    case noInternet
    case internetAvailable
}
