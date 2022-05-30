//
//  InvertedUserListingCellViewModel.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

class InvertedUserListingCellViewModel: BaseUserListCellViewModel {
    
    var cellName: String = InvertedUserListingCell.reuseIdentifier
    
    var profileSeen: Bool
    var userName: String
    var isNotesAdded: Bool
    var userType: String
    var url: URL?
    
    init(userName: String, userType: String, imageURL: URL?, profileSeen: Bool, notesAdded: Bool) {
        self.userName = userName
        self.userType = userType
        self.url = imageURL
        self.profileSeen = profileSeen
        self.isNotesAdded = notesAdded
    }
}
