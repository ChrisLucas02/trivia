//
//  HistoryTableViewController.swift
//  Trivia
//
//  Created by Chris Lucas on 14.08.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine
import CoreData

class HistoryTableViewController: UITableViewController {
    
    // MARK: - Attributes
    
    private var viewModel:HistoryTableViewModel = HistoryTableViewModel()
    var questions:[Question] = []
    var question:Question?

    
    // MARK: - UITableViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questions = viewModel.getDataDB()
        // add small space around the table and remove the list separators
        self.tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0);
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath) as! HistoryTableViewCell
        
        cell.question.text = questions[indexPath.row].question
        cell.category.text = questions[indexPath.row].category
        if questions[indexPath.row].correct {
            cell.state.image = UIImage(named: "Correct")
        } else {
            cell.state.image = UIImage(named: "Wrong")
        }

        cell.actionBlock = {
            self.question = self.questions[indexPath.row].self
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "replaySegue"){
            let vc = segue.destination as? MultipleChoiceViewController
            vc?.replayQuestion = question
        }
    }
    
}
