//
//  CategoryTableViewController.swift
//  Trivia
//
//  Created by Chris Lucas on 14.08.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine

class CategoryTableViewController: UITableViewController {
    
    // MARK: - Attributes
    // UI
    private var tableLoadingView: LoadingView!
    @IBOutlet var categoryTable: UITableView!
    // ViewModel
    var viewModel: CategoryTableViewModel = CategoryTableViewModel()
    private var subcriptions: Set<AnyCancellable> = []
    // delegate
    // singleton
    static var shared = CategoryTableViewController()
    // extra
    var idCategorySelected:Int = 0
    
    // MARK: - UITableViewController overrides
    override func viewDidDisappear(_ animated: Bool) {
        self.subcriptions.removeAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
        setupTableView()
        bindViewModel()
    }
    
    // MARK: - Combine things
    private func bindViewModel(){
        viewModel.categories.sink { [unowned self] (data) in
            if !data.isEmpty {
                self.categoryTable.delegate = self
                self.categoryTable.dataSource = self
                self.tableLoadingView.hideLoadingView();
                self.categoryTable.reloadData()
            }
        }.store(in: &subcriptions)
    }
    
    private func setupTableView(){
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }
    
    private func showLoader(){
        self.tableLoadingView = LoadingView(superView: self.view, navigationController: self.navigationController, label: "Loading...")
        self.tableLoadingView.showLoadingView()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.categories.value.count// TODO: - To complete
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryTableViewCell", for: indexPath) as! CategoryTableViewCell
        
        // TODO: - To complete
        cell.category.setTitle(viewModel.categories.value[indexPath.row].name, for: .normal)
        cell.actionBlock = {
            self.idCategorySelected = self.viewModel.categories.value[indexPath.row].id
        }
        return cell
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "playSegue"){
            let vc = segue.destination as? MultipleChoiceViewController
            vc?.idCategory = idCategorySelected
        }
    }
    
}
