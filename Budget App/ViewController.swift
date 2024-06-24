//
//  ViewController.swift
//  Budget App
//
//  Created by Mohd Kashif on 23/06/24.
//

import UIKit
import CoreData
class ViewController: UITableViewController {
    private var container:NSPersistentContainer
    private var resultController:NSFetchedResultsController<BudgetCategory>!
    init(container: NSPersistentContainer) {
        self.container = container
        let request=BudgetCategory.fetchRequest()
        request.sortDescriptors=[NSSortDescriptor(key: "name", ascending: true)]
        resultController=NSFetchedResultsController(fetchRequest: request, managedObjectContext: container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init(nibName: nil, bundle: nil)
        resultController.delegate=self
        do{
            try resultController.performFetch()
        } catch let error{
            print(error.localizedDescription,"error in fetch")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor=UIColor.white
        setupUI()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @objc func addBudgetCategory(_ item:UIBarButtonItem){
        let controller=UINavigationController(rootViewController: AddBudgetViewController(container: container))
        present(controller, animated: true)
    }
    
    private func setupUI(){
        let button=UIBarButtonItem(title: "Add Category", style: .done, target: self, action: #selector(addBudgetCategory))
        self.navigationItem.rightBarButtonItem=button
        navigationController?.navigationBar.prefersLargeTitles=true
        title="Budget"
    }
    
    //
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (resultController.fetchedObjects ?? []).count
    }
    
    // Return cell of which items are gonna dispplay
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) ///
        let budgetCategory=resultController.object(at: indexPath)
        var config=cell.defaultContentConfiguration()
        config.text=budgetCategory.name
        cell.contentConfiguration=config
        return cell
    }
}

extension ViewController:NSFetchedResultsControllerDelegate{
    // this delegate function get fired whenever congent change
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<any NSFetchRequestResult>) {
        tableView.reloadData() // we are just reloading the tableView
    }
}
