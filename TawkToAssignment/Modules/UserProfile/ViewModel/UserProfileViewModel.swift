//
//  UserProfileViewModel.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
typealias UserProfileViewModelOutputHandler = (UserProfileViewModelOutput) -> ()

protocol UserProfileViewModel {
    
    var service : UsersService { get }
    var userProfile: UserProfile? { get set }
    var title: String { get }
    var completionHandler: UserProfileViewModelOutputHandler? { get set }
    var delegate: UserProfileViewModelDelegate? { get set }
    func viewDidLoad()
    func saveNotes(withText: String)
}

enum UserProfileViewModelOutput {
    case showLoader
    case hideLoader
    case updateProfile
    case showAlert(withMessage: String)
}
