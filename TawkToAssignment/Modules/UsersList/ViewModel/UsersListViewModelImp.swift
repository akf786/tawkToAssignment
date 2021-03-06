//
//  UsersListViewModelImp.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

class UsersListViewModelImp: UsersListViewModel {
    
    private var users = [User]()
    private var searchedUsers = [User]()
    private var isSearching = false
    private var cellViewModels = [BaseUserListCellViewModel]()
    
    private var since = 0
    private var isApiCalled = false
    
    var service: UsersService
    weak var coordinatorDelegate: UsersListViewModelCoordinatorDelegate?
    
    var completionHandler: UsersListViewModelOutputHandler?
    
    
    //MARK: - Initializer
    init(users: [User], service: UsersService) {
        self.service = service
        self.users = users
        self.since = UserDefaultsManager.shared.getSinceValue()
    }
    
    func viewDidLoad() {
        self.fetchSavedUserList()
        self.fetchUsers()
    }
    
    
    //MARK: - Computed Properties
    var numberOfRows: Int {
        return self.cellViewModels.count
    }
    
    var title: String {
        return AppConstants.Constants.usersList
    }
    
    
    //MARK: - Helper Methods
    func getCellVMAt(index: Int) -> BaseUserListCellViewModel {
        return self.cellViewModels[index]
    }
    
    
    func fetchUsers(bottomScrolling: Bool? = false) {
        if !self.isApiCalled && !self.isSearching {
            self.fetchUsersList()
            if !(bottomScrolling ?? false) {
                self.completionHandler?(.showLoader)
            }
            self.completionHandler?(.internetAvailable)
        }
    }
    
    func tappedAtCell(index: Int) {
        var user: User
        ///Logic: If user is searching then it should get the user from searchedUsers Array else fetch from the normal users list
        if isSearching {
            user = self.searchedUsers[index]
        } else {
            user = self.users[index]
        }
        
        ///Logic: On clicking any of the user profile saving the profile status to seen on DB
        self.service.setStatusToSeenFor(userName: user.login ?? "") { [weak self] in
            guard let weakSelf = self else {
                return
            }
            
            self?.users[index].isSeen = true
            weakSelf.coordinatorDelegate?.didTapOnUser(user: user, delegate: weakSelf)
        }
        
    }
    
    func appendCellViewModels(for users: [User]) {
        var count = 0
        for user in users {
            count = count + 1
            
            let viewModel: BaseUserListCellViewModel
            
            ///Logic: For every fourth cell InvertedCell is being initialized otherwise if user has some notes then notes cell else normal cell
            let isInvertedCell = count % 4 == 0
            if isInvertedCell {
                viewModel = InvertedUserListingCellViewModel(userName: user.login ?? "",
                                                             userType: user.type ?? "",
                                                             imageURL: URL(string: user.avatarURL ?? ""),
                                                             profileSeen: user.isSeen,
                                                             notesAdded: user.isNotesAdded)
            } else {
                if user.isNotesAdded {
                    viewModel = NoteUserListingCellViewModel(userName: user.login ?? "",
                                                             userType: user.type ?? "",
                                                             imageURL: URL(string: user.avatarURL ?? ""),
                                                             profileSeen: user.isSeen)
                } else {
                    viewModel = NormalUserListingCellViewModel(userName: user.login ?? "",
                                                               userType: user.type ?? "",
                                                               imageURL: URL(string: user.avatarURL ?? ""),
                                                               profileSeen: user.isSeen)
                }
            }
                        
            self.cellViewModels.append(viewModel)
        }
        
        self.completionHandler?(.refreshData)
    }
    
    func searchUser(text: String) {
        self.cellViewModels = []
        self.isSearching = !text.isEmpty
        if text.isEmpty {
            self.appendCellViewModels(for: self.users)
            
        } else {
            self.searchedUsers = []
            let list = self.users.filter { user in
                
                ///Logic: Searching user based on its username and also on the basis of its profile notes.
                let isUserNameContains = user.login?.localizedCaseInsensitiveContains(text) ?? false
                let isNotesContains = user.notes?.localizedCaseInsensitiveContains(text) ?? false
                return isUserNameContains || isNotesContains
            }
            
            self.searchedUsers.append(contentsOf: list)
            self.appendCellViewModels(for: self.searchedUsers)
        }
    }
    
}


//MARK: - Api Call
extension UsersListViewModelImp {
    
    private func refreshData(_ users: [User]) {
        self.users.append(contentsOf: users)
        self.appendCellViewModels(for: users)
    }
 
    private func fetchSavedUserList() {
        self.service.fetchLocalUserList { [weak self] localUsersList in
            self?.refreshData(localUsersList ?? [])
        }
    }
    
    private func fetchUsersList() {
        self.isApiCalled = true
        
        self.service.getUsersList(since: self.since) { [weak self] result in

            guard let `self` = self else {
                return
            }

            self.isApiCalled = false

            self.completionHandler?(.hideLoader)

            switch result {

            case .success(let newUsers):
                
                self.completionHandler?(.hideEmptyView)
                self.since = Int(newUsers.last?.id ?? 0)
                UserDefaultsManager.shared.saveLastSinceValue(self.since)
                self.refreshData(newUsers)
                
                break

            case .failure(_):
                if self.users.count == 0 {
                    self.completionHandler?(.showEmptyView)
                    self.completionHandler?(.refreshData)
                }
            }
        }
    }
    
    
}


//MARK: - UserProfileViewModelDelegate
extension UsersListViewModelImp: UserProfileViewModelDelegate {
    
    func didSaveNoteFor(userId: Int16, notes: String) {
        if let index = self.users.firstIndex(where: { $0.id == userId }) {
            ///Logic:  Changing status for a specific user on local array so it will reflect on coming back from user profile
            self.users[index].isNotesAdded = true
            self.users[index].notes = notes
            self.users[index].isSeen = true
            self.cellViewModels = []
            self.appendCellViewModels(for: self.users)
        }
    }
    
    func didSaveProfile(userId: Int16) {
        if let index = self.users.firstIndex(where: { $0.id == userId }) {
            self.users[index].isSeen = true
            self.cellViewModels = []
            self.appendCellViewModels(for: self.users)
        }
    }
    
}
