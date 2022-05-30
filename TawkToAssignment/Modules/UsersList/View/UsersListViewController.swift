//
//  UsersListViewController.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

class UsersListViewController: UIViewController {

    var viewModel: UsersListViewModel?
    
    //MARK: - Outlets
    @IBOutlet var usersListingView: UsersListView!
   
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerNibs()
        self.setupTableView()
        self.bindViewModel()
        self.addClickToDismissView()
        self.title = viewModel?.title
        self.usersListingView.searchView.delegate = self
        self.usersListingView.noInternetHeightCnst.constant = 0
        self.viewModel?.viewDidLoad()
        
        
    }

    
    //MARK: - Actions
    @objc
    func singleTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
}

//MARK: - ViewModel Binding
extension UsersListViewController {
    
    private func bindViewModel() {
        self.viewModel?.completionHandler = { [weak self] output in
            switch output {
            case .hideLoader:
                DispatchQueue.main.async {
                    self?.usersListingView.activityIndicator.stopAnimating()
                }
                
                
            case .showLoader:
                DispatchQueue.main.async {
                    self?.usersListingView.activityIndicator.startAnimating()
                }
                
            case .refreshData:
                DispatchQueue.main.async {
                    self?.usersListingView.tableView.reloadData()
                }
            
            case .showEmptyView:
                DispatchQueue.main.async {
                    self?.usersListingView.emptyListView.isHidden = false
                }
                
            case .hideEmptyView:
                DispatchQueue.main.async {
                    self?.usersListingView.emptyListView.isHidden = true
                }
                
            case .noInternet:
                DispatchQueue.main.async {
                    self?.usersListingView.activityIndicator.stopAnimating()
                    self?.usersListingView.noInternetHeightCnst.constant = 50
                    self?.usersListingView.noInternetLabel.isHidden = false
                }
                break
                
            case  .internetAvailable:
                DispatchQueue.main.async {
                    self?.usersListingView.noInternetHeightCnst.constant = 0
                    self?.usersListingView.noInternetLabel.isHidden = true
                }
                break
            
            }
        }
    }
    
}

//MARK: - Private Methods
extension UsersListViewController {
    
    private func registerNibs() {
        self.usersListingView.tableView.register(nibClassType: NormalUserListingCell.self)
        self.usersListingView.tableView.register(nibClassType: InvertedUserListingCell.self)
        self.usersListingView.tableView.register(nibClassType: NoteUserListingCell.self)
    }
    
    private func setupTableView() {
        self.usersListingView.tableView.dataSource = self
        self.usersListingView.tableView.delegate = self
    }
    
    private func addClickToDismissView() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.singleTap(sender:)))
        singleTapGestureRecognizer.numberOfTapsRequired = 1
        singleTapGestureRecognizer.isEnabled = true
        singleTapGestureRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
}


//MARK: - TableViewDelegate
extension UsersListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cellVM = viewModel?.getCellVMAt(index: indexPath.row) else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellVM.cellName, for: indexPath)
        if let baseCell = cell as? BaseUserListCell {
            baseCell.configure(viewModel: cellVM)
        }
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        
        if indexPath.row == viewModel.numberOfRows - 1 {
            viewModel.fetchUsers()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel?.tappedAtCell(index: indexPath.row)
    }
}


extension UsersListViewController: SearchViewDelegate {
    
    func searchText(text: String) {
        self.viewModel?.searchUser(text: text)
    }
    
}
