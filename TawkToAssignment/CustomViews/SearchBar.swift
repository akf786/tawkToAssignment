//
//  SearchBar.swift
//  TawkToAssignment
//
//  Created by Macbook on 30/05/2022.
//

import UIKit

protocol SearchViewDelegate: class {
    func searchText(text: String)
}

class SearchBar: UIView {

    private let searchViewNibName = "SearchBar"
    
    private var timer: Timer?
    
    var view: UIView!

    weak var delegate: SearchViewDelegate?
    
    //MARK: - Properties
    @IBInspectable
    var enableSearch: Bool = true {
        didSet {
            self.searchTextField.isEnabled = enableSearch
        }
    }
    
    @IBInspectable
    var placeholder: String = "" {
        didSet {
            self.searchTextField.placeholder = placeholder
        }
    }
    

    //MARK: - Outlets
    @IBOutlet weak var searchTextField: UITextField! {
        didSet {
            searchTextField.font = AppConstants.Font.medium(size: 14)
            searchTextField.textColor = AppConstants.Colors.primaryColor
            searchTextField.delegate = self
            searchTextField.autocorrectionType = .no
        }
    }
    
    @IBOutlet weak var searchFieldOuterView: UIView! {
        didSet {
            searchFieldOuterView.backgroundColor = UIColor(hexString: "#F5F5F5")
            searchFieldOuterView.layer.cornerRadius = 8
        }
    }
    
    @IBOutlet weak var crossView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: - Override Methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        self.searchTextField.delegate = self
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.hideCrossButtonView()
        
    }
    
    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: searchViewNibName, bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        return view ?? nil
    }
    
    
    //MARK: - Actions
    @objc
    func timerCalled(_ sender: Timer) {
        guard let userInfo =  sender.userInfo as? [String: Any],
            let searchString  = userInfo["searchString"] as? String else {
            return
        }
        
        self.delegate?.searchText(text: searchString)
    }
    
    @objc
    func cancelButtonTapped(_ sender: UIButton) {
        self.searchTextField.text = ""
        self.delegate?.searchText(text: "")
    }

    
    //MARK: - Private Methods
    private func startTimerforCallService(searchString: String) {
        timer?.invalidate()
        if searchString.count > 2 {
            timer = Timer.scheduledTimer(timeInterval: 0.5,
                                         target: self,
                                         selector: #selector(timerCalled),
                                         userInfo: ["searchString": "\(searchString)"],
                                         repeats: false)
        }
    }
    
    
    
    private func showCrossButtonView() {
        self.crossView.isHidden = false
        self.cancelButton.isEnabled = true
    }
    
    private func hideCrossButtonView() {
        self.crossView.isHidden = true
        self.cancelButton.isEnabled = false
    }
    
}



//MARK: - UITextField Delegate
extension SearchBar: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        if !text.isEmpty && text.count > 2 {
            self.delegate?.searchText(text: text)
        }
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showCrossButtonView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.hideCrossButtonView()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text,
           let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if updatedText.isEmpty {
                self.delegate?.searchText(text: "")
            }
            self.startTimerforCallService(searchString: updatedText)
        }
        
        return true
    }
    
}
