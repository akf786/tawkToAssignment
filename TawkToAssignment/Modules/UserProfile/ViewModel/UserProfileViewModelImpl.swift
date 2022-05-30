//
//  UserProfileViewModelImpl.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

class UserProfileViewModelImpl: UserProfileViewModel {
    
    var userProfile: UserProfile?
    private var user: User
    
    
    var service: UsersService
    
    
    var completionHandler: UserProfileViewModelOutputHandler?
    
    
    //MARK: - Initializer
    init(user: User, service: UsersService) {
        self.service = service
        self.user = user
        
    }
    
    
    //MARK: - Computed Properties
    var title: String {
        return AppConstants.Constants.profile
    }
    
    
    //MARK: - Helper Methods
    func viewDidLoad() {
        self.getUserProfile()
    }
    
    func saveNotes(withText: String) {
        self.service.saveNotesOf(userName: self.user.login ?? "", withNotes: withText) { [weak self] in
            self?.service.setStatusOfNotesAdded(userName: self?.user.login ?? "", completionHandler: {
                    
                self?.completionHandler?(.showAlert(withMessage: "User notes updated"))
            })
        }
    }
    
}


//MARK: - Api Call
extension UserProfileViewModelImpl {
    
    private func getUserProfile() {
        completionHandler?(.showLoader)
        self.service.getUserProfile(userName: self.user.login ?? "") { [weak self] result in
            
            self?.completionHandler?(.hideLoader)
            
            switch result {
            
            case .success(let profile):
                self?.userProfile = profile
                self?.completionHandler?(.updateProfile)
                
            case .failure(_):
                break
            }
        }
    }
}

