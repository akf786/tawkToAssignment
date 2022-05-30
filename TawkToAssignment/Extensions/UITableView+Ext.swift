//
//  UITableView+Ext.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation
import UIKit

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: .main)
    }
}

extension UITableViewCell: ReuseIdentifying {}

extension UITableView {
    
    /// Register Cell with nib
    ///
    /// - Parameter _: provide type parameter
    func register<T: UITableViewCell>(nibClassType _: T.Type) {
        register(.init(nibName: T.reuseIdentifier, bundle: .main), forCellReuseIdentifier: T.reuseIdentifier)
    }
    
}
