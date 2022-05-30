//
//  UserProfileViewController.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class UserProfileViewController: UIViewController {

    var viewModel: UserProfileViewModel?
    
    
    //MARK: - Outlets
    @IBOutlet var userProfileView: UserProfileView!
    
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel?.title
        self.bindViewModel()
        self.viewModel?.viewDidLoad()
        self.view.backgroundColor = AppConstants.Colors.outerViewColor
    }
    
    
    //MARK: - Actions
    @IBAction
    func saveButton(_ sender: UIButton) {
        self.viewModel?.saveNotes(withText: self.userProfileView.notesTextView.text)
    }
    
    
}

//MARK: - ViewModel Binding
extension UserProfileViewController {
    
    private func bindViewModel() {
        self.viewModel?.completionHandler = { [weak self] output in
            switch output {
            case .hideLoader:
                DispatchQueue.main.async {
                    self?.userProfileView.activityIndicator.stopAnimating()
                }
                
                
            case .showLoader:
                DispatchQueue.main.async {
                    self?.userProfileView.activityIndicator.startAnimating()
                }
                
            case .updateProfile:
                DispatchQueue.main.async {
                    self?.initializeData()
                }
                break
            
            case .showAlert(let message):
                DispatchQueue.main.async {
                    guard let weakSelf = self else {
                        return
                    }
                    
                    AppConstants.showAlert(title: "", message: message, viewController: weakSelf)
                }
            }
        }
    }
}


//MARK: - Private Methods
extension UserProfileViewController {
    
    private func initializeData() {
        guard let vM = self.viewModel,
              let profileDetail = vM.userProfile else {
            return
        }
        
        if profileDetail.name?.isEmpty ?? true {
            self.userProfileView.userFullNameLabel.isHidden = true
        }
        
        self.userProfileView.userFullNameLabel.text = profileDetail.name
        self.userProfileView.userNameLabel.text = profileDetail.login
        self.userProfileView.publicReposCount.text = "\(profileDetail.publicRepos )"
        self.userProfileView.followingCount.text = "\(profileDetail.following )"
        self.userProfileView.followersCount.text = "\(profileDetail.followers )"
        self.userProfileView.notesTextView.text = profileDetail.notes
        
        DispatchQueue.global(qos: .userInteractive).async {
            if let avatarUrl = profileDetail.avatarURL, let imageUrl = URL(string: avatarUrl) {
                self.userProfileView.userProfileImage.downloadImage(from: imageUrl)
            }
        }
    }
    
}
