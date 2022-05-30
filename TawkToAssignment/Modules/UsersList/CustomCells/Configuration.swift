//
//  Configuration.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import Foundation

protocol BaseUserListCellViewModel {
    var cellName: String { get }
}

protocol BaseUserListCell {
    func configure(viewModel: BaseUserListCellViewModel)
}
