//
//  InvertedUserListingCell.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class InvertedUserListingCell: UITableViewCell, BaseUserListCell {

    //MARK: - Outlets
    @IBOutlet weak var userNameLabel: UILabel! {
        didSet {
            userNameLabel.textColor = AppConstants.Colors.titleColor
            userNameLabel.font = AppConstants.Font.medium(size: 16)
        }
    }
    
    @IBOutlet weak var userType: UILabel! {
        didSet {
            userType.textColor = AppConstants.Colors.subHeadingColor
            userType.font = AppConstants.Font.medium(size: 12)
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            userImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.addShadowsOnly(offset: CGSize(width: 0, height: 0), color: UIColor.black, radius: 4, opacity: 0.20)
        }
    }
    
    @IBOutlet weak var notesIcon: UIImageView!
    
    @IBOutlet weak var imageOuterView: UIView! {
        didSet {
            imageOuterView.backgroundColor = .clear
            imageOuterView.layer.cornerRadius = 25
        }
    }
    
    //MARK: - ViewModel Configuration
    func configure(viewModel: BaseUserListCellViewModel) {
        guard let vm = viewModel as? InvertedUserListingCellViewModel else {
            return
        }
        
        self.userNameLabel.text = vm.userName
        self.userType.text = vm.userType
        if vm.profileSeen {
            self.outerView.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        } else {
            self.outerView.backgroundColor = .clear
        }
        
        notesIcon.isHidden = !vm.isNotesAdded
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let imageUrl = vm.url {
                self.userImageView.downloadImage(from: imageUrl)
            }
        }
        
    }
}
