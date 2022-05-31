//
//  UserProfileViewController.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class UserProfileViewController: UIViewController {

    private var keyboardHeight: CGFloat = 0.0
    private let keyboardNotificationNames = ["UIKeyboardWillShowNotification",
                                             "UIKeyboardWillChangeFrameNotification",
                                             "UIKeyboardWillHideNotification",
                                             "UIKeyboardDidChangeFrameNotification"]
    
    //MARK: - Outlets
    @IBOutlet var userProfileView: UserProfileView!
    
    
    var viewModel: UserProfileViewModel?
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel?.title
        self.showInternetView()
        self.bindViewModel()
        self.viewModel?.viewDidLoad()
        self.addClickToDismissView()
        self.view.backgroundColor = AppConstants.Colors.appBackgroundColor
        self.userProfileView.activityIndicator.stopAnimating()
        self.addNotificationObserver()
        self.registerForKeyboardNotifications()
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        userProfileView.bottomHeightCnst.constant = keyboardHeight
    }
    
    deinit {
        print("Deinit called")
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    @IBAction
    func saveButton(_ sender: UIButton) {
        self.viewModel?.saveNotes(withText: self.userProfileView.notesTextView.text)
    }
    
    @objc
    func singleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc
    func networkConnection(notification: NSNotification) {
        if let internetAvailable = notification.object as? Bool {
            if internetAvailable {
                self.showInternetView()
                self.viewModel?.viewDidLoad()
            } else {
                self.showNoInternetView()
            }
        }
    }
    
    @objc
    func keyboardWillChangeFrame(_ notification: NSNotification) {
        guard let keyboardEndFrameWindow = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        let keyboardEndFrameView = userProfileView.convert(keyboardEndFrameWindow, from: nil)
        if keyboardEndFrameView.origin.y == userProfileView.frame.size.height {
            keyboardHeight = 0
        } else {
            keyboardHeight = keyboardEndFrameView.size.height
        }
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
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
    
    private func addClickToDismissView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    private func addNotificationObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkConnection(notification:)),
                                               name: Notification.Name(AppConstants.Constants.notificationName),
                                               object: nil)

    }
    
    private func showNoInternetView() {
        self.userProfileView.activityIndicator.stopAnimating()
        self.userProfileView.noInternetHeightCnst.constant = 50
        self.userProfileView.noInternetLabel.isHidden = false
    }
    
    private func showInternetView() {
        self.userProfileView.noInternetHeightCnst.constant = 0
        self.userProfileView.noInternetLabel.isHidden = true
    }
    
    private func registerForKeyboardNotifications() {
        for notification in keyboardNotificationNames {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(keyboardWillChangeFrame(_:)),
                                                   name: NSNotification.Name(notification),
                                                   object: nil)
        }
    }
    
    private func removeForKeyBoardNotification() {
        for notification in keyboardNotificationNames {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(notification), object: nil)
        }
    }

    
}
