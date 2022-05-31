//
//  UsersListView.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class UsersListView: UIView {

    @IBOutlet weak var searchView: SearchBar!
    
    @IBOutlet weak var noInternetView: UIView!
    
    @IBOutlet weak var noInternetHeightCnst: NSLayoutConstraint!
    
    @IBOutlet weak var noInternetLabel: UILabel! {
        didSet {
            noInternetLabel.textColor = AppConstants.Colors.appWhiteColor
            noInternetLabel.font = AppConstants.Font.medium(size: 16)
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.separatorColor = .clear
            tableView.keyboardDismissMode = .onDrag
        }
    }
    
    @IBOutlet weak var emptyListView: UIView! {
        didSet {
            emptyListView.isHidden = true
        }
    }
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = AppConstants.Colors.primaryColor
        }
    }
    
    @IBOutlet weak var outerView: UIView! {
        didSet {
            outerView.backgroundColor = AppConstants.Colors.appBackgroundColor
        }
    }
        
    @IBOutlet weak var emptyViewTitleLabel: UILabel! {
        didSet {
            emptyViewTitleLabel.textColor = AppConstants.Colors.titleColor
            emptyViewTitleLabel.font = AppConstants.Font.medium(size: 16)
        }
    }

}
