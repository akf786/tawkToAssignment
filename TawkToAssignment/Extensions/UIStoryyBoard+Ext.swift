//
//  UIStoryyBoard+Ext.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit


/**
 For initializeing story board and instantiaing ViewController .
 
 - storyboardIdentifier : Should be same as class name
 - storyboardName : storyboard enum
 - instantiateViewController : for instantiating viewcontroller
 */

protocol StoryboardInitializable {
    static var storyboardIdentifier: String { get }
    static var storyboardName: UIStoryboard.Storyboard { get }
    static func instantiateViewController() -> UIViewController
}


/**
 - Storyboard : enum for saving storyboard name
 - storyboard : initialise storyboard
 */
extension UIStoryboard {

    enum Storyboard: String {
        case main
        var filename: String {
            return rawValue.capitalized
        }
    }
    
    class func storyboard(storyboard: Storyboard, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: bundle)
    }
    
}

extension StoryboardInitializable where Self: Coordinator {
    /**
     define in protocol file
     
     */
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
    
    static var storyboardName: UIStoryboard.Storyboard {
        return UIStoryboard.Storyboard.main
    }
    
    static func instantiateViewController() -> UIViewController {
        let storyboard = UIStoryboard.storyboard(storyboard: storyboardName)
        return storyboard.instantiateViewController(withIdentifier: storyboardIdentifier)
        
    }
}
