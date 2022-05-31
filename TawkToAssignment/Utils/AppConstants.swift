//
//  AppConstants.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit


class AppConstants {
    
    static func showAlert(title: String, message: String, viewController: UIViewController, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
        alertController.addAction(okAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    struct Constants {
        static let profile = "Profile"
        static let usersList = "Users"
        static let error = "Error"
        static let notificationName = "NetworkConnectivity"
    }
    
    struct Colors {
        static let appBackgroundColor = UIColor(named: "background")
        static let titleColor = UIColor(named: "titleColor")
        static let subHeadingColor = UIColor(named: "subHeadingColor")
        
        static let appWhiteColor = UIColor(hexString: "#ffffff")
        static let primaryColor = UIColor(hexString: "#2AADE0")
        
    }

    struct EndPoints {
        static let getAllUsers = "https://api.github.com/users"
        static let getUserProfile = "https://api.github.com/users/"
    }
    
    struct Font {
        
        static func medium(size: CGFloat) -> UIFont? {
            return UIFont(name: "Avenir-Medium", size: size)
        }
        
        static func regular(size: CGFloat) -> UIFont? {
            return UIFont(name: "AvenirNext-Regular", size: size)
        }
    
    }
    
}

