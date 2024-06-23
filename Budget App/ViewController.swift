//
//  ViewController.swift
//  Budget App
//
//  Created by Mohd Kashif on 23/06/24.
//

import UIKit
import CoreData
class ViewController: UIViewController {
    private var container:NSPersistentContainer
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
        setupUI()
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
}

