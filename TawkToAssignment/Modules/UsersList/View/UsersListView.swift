//
//  UsersListView.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class UsersListView: UIView {

    @IBOutlet weak var searchView: SearchBar!
    
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
            tableView.separatorColor = .clear
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
            emptyViewTitleLabel.textColor = AppConstants.Colors.headingColor
            emptyViewTitleLabel.font = AppConstants.Font.medium(size: 16)
        }
    }

}
