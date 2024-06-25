//
//  BudgetDetailViewContoller.swift
//  Budget App
//
//  Created by Mohd Kashif on 24/06/24.
//

import Foundation
import UIKit
import CoreData
class BudgetDetailViewContoller:UIViewController{
    private var container:NSPersistentContainer
    private var budgetCategory:BudgetCategory
    
    private var resultController:NSFetchedResultsController<Transaction>!
    
    lazy var nameField:UITextField={
        let textField=UITextField()
        textField.placeholder="Transaction Name"
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    lazy var amountField:UITextField={
        let textField=UITextField()
        textField.placeholder="Transaction Amount"
        textField.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        textField.leftViewMode = .always
        textField.borderStyle = .roundedRect
        return textField
    }()
    lazy var errorLabel:UILabel={
        let label=UILabel()
        label.textColor=UIColor.red
        label.text=""
        label.font=label.font.withSize(12)
        label.numberOfLines=0
        return label
    }()
    
    lazy var totalAmount:UILabel={
       let label=UILabel()
        label.numberOfLines=0
        label.textAlignment = .center
        return label
    }()
    
    lazy var saveButton:UIButton={
        var config=UIButton.Configuration.bordered()
        let button=UIButton(configuration: config)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.setTitle("Save Transaction", for: .normal)
        return button
    }()
    
    lazy var tableView:UITableView={
        let tableView=UITableView()
        tableView.delegate=self
        tableView.dataSource=self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TransactionCell")
        return tableView
    }()
    
    lazy var amountLabel:UILabel={
        let label=UILabel()
        label.text=budgetCategory.amount.formatCurrency()
        label.font=label.font.withSize(20)
        return label
    }()
    
//    private var transactionTotal:Double{
//        let transaction=resultController.fetchedObjects ?? []
//        return 0
//    }
    init(budgetCategory:BudgetCategory, container: NSPersistentContainer) {
        self.budgetCategory=budgetCategory
        self.container = container
        super.init(nibName: nil, bundle: nil)
        
        let request=Transaction.fetchRequest()
        request.predicate=NSPredicate(format: "category=%@", budgetCategory)
        request.sortDescriptors=[NSSortDescriptor(key: "date", ascending: false)]
        resultController=NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        resultController.delegate=self
        do{
            try resultController.performFetch()
        } catch let error{
            print(error.localizedDescription)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        totalAmount.text=budgetCategory.totalTransaction.formatCurrency()
        
    }
    
    func getTransaction(){
        var total:Double=0
        let tranction=resultController.fetchedObjects ?? []
        for i in tranction{
            total += i.amount
        }
        totalAmount.text="Total:- \(total.formatCurrency())"
    }
    private func reset(){
        nameField.text=""
        amountField.text=""
        errorLabel.text=""
    }
    @objc func addTranstion(_ button:UIButton){
        guard let name=nameField.text, let amount=amountField.text else{
            return
        }
        if !name.isEmpty && !amount.isEmpty && amount.isNumeric && amount.isGreaterThan(0){
            saveTransaction(name: name, amount: amount)
        } else {
            errorLabel.text="Unable to add. Pleaes add required field"
        }
    }
    
    private func saveTransaction(name:String, amount:String){
        let transaction=Transaction(context: container.viewContext)
        transaction.name=name
        transaction.amount=Double(amount) ?? 0.0
        transaction.date=Date()
        transaction.category=budgetCategory
        errorLabel.text=""
        do{
            try container.viewContext.save()
            reset()
        } catch let error{
            print(error.localizedDescription,"error")
        }
    }
    private func setupUI(){
        view.backgroundColor=UIColor.white
        navigationController?.navigationBar.prefersLargeTitles=true
        title=budgetCategory.name
        
        let stack=UIStackView()
        
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints=false
        stack.spacing=UIStackView.spacingUseSystem
        stack.isLayoutMarginsRelativeArrangement=true
        stack.directionalLayoutMargins=NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        stack.addArrangedSubview(amountLabel)
        stack.setCustomSpacing(30, after: amountLabel)
        stack.addArrangedSubview(nameField)
        stack.addArrangedSubview(amountField)
        stack.addArrangedSubview(saveButton)
        stack.addArrangedSubview(errorLabel)
        stack.addArrangedSubview(totalAmount)
        stack.addArrangedSubview(tableView)
        
        saveButton.addTarget(self, action: #selector(addTranstion), for: .touchUpInside)
        
        view.addSubview(stack)
        //add constraint to properties
        nameField.widthAnchor.constraint(equalToConstant: 200).isActive=true
        amountField.widthAnchor.constraint(equalToConstant: 200).isActive=true
        saveButton.centerXAnchor.constraint(equalTo: stack.centerXAnchor).isActive=true
        
        stack.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive=true
        
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive=true
        tableView.heightAnchor.constraint(equalToConstant: 600).isActive=true
        
    }
    private func deleteTransaction(_ transaction:Transaction){
        container.viewContext.delete(transaction)
        do{
            try container.viewContext.save()
        } catch let error{
            errorLabel.text=error.localizedDescription
            print(error.localizedDescription)
        }
        
    }
}

extension BudgetDetailViewContoller: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return (resultController.fetchedObjects ?? []).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath)
        let transcation=resultController.object(at: indexPath)
        var config=cell.defaultContentConfiguration()
        config.text=transcation.name
        config.secondaryText=transcation.amount.formatCurrency()
        cell.contentConfiguration=config
        return cell
    }
}



extension BudgetDetailViewContoller: UITableViewDelegate{
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let transaction=resultController.object(at: indexPath)
            deleteTransaction(transaction)
            
        }
    }
}


extension BudgetDetailViewContoller: NSFetchedResultsControllerDelegate{
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData()
        getTransaction()
    }
}
