//
//  AddBudgetViewController.swift
//  Budget App
//
//  Created by Mohd Kashif on 24/06/24.
//

import Foundation
import UIKit
import CoreData
class AddBudgetViewController:UIViewController{
    private var container:NSPersistentContainer
    
    lazy var nameField:UITextField={
        let textField=UITextField()
        textField.placeholder="Enter Budget Name"
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountField:UITextField={
        let textField=UITextField()
        textField.placeholder="Enter Amount"
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var addBudgetButton:UIButton={
        var config=UIButton.Configuration.bordered()
       let button=UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Save", for: .normal)
        return button
    }()
    
    lazy var errorLabel:UILabel={
       let label=UILabel()
        label.textColor=UIColor.red
        label.text=""
        label.font=label.font.withSize(12)
        label.numberOfLines=0
        return label
    }()
    
    init(container: NSPersistentContainer) {
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        navigationController?.navigationBar.prefersLargeTitles=true
        title="Add Budget"
        setupUI()
        
    }
    
    private var isValid:Bool{
        guard let name=nameField.text, let amount=amountField.text else {
            return false
        }
        return !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0)
    }
    @objc private func buttonAction(){
        if isValid{
            errorLabel.text=""
        } else {
            errorLabel.text="Unable to save data"
        }
    }
    
    private func setupUI(){
        let stack=UIStackView()
        stack.alignment = .leading
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement=true
        stack.directionalLayoutMargins=NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        stack.spacing=UIStackView.spacingUseSystem
        
        view.addSubview(stack)
        
        stack.addArrangedSubview(nameField)
        stack.addArrangedSubview(amountField)
        stack.addArrangedSubview(addBudgetButton)
        stack.addArrangedSubview(errorLabel)
        
        nameField.widthAnchor.constraint(equalToConstant: 300).isActive=true
        amountField.widthAnchor.constraint(equalToConstant: 300).isActive=true
        addBudgetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
        
        addBudgetButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        stack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive=true
    }
}
