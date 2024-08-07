//
//  ProfileViewController.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {

    // MARK: - Attributes
    
    @IBOutlet weak var countGold: UILabel!          // number of gold medals won
    @IBOutlet weak var countSilver: UILabel!        // number of silver medals won
    @IBOutlet weak var countBronze: UILabel!        // number of bronze medals won
    @IBOutlet weak var playerRating: UILabel!       // player rating (correct answers/total answers * 100)
    @IBOutlet weak var countTrivia: UILabel!        // number of games completed
    @IBOutlet weak var countAnswered: UILabel!      // number of questions answered
    @IBOutlet weak var countCorrect: UILabel!       // number of questions correctly answered
    
    private var viewModel:ProfileViewModel = ProfileViewModel()
    
    // MARK: - UIViewController overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let statistic:Statistic = viewModel.fetchStatistic()
        countGold.text = "\(statistic.nbGold)"
        countSilver.text = "\(statistic.nbSilver)"
        countBronze.text = "\(statistic.nbBronze)"
        playerRating.text = "\(String(format: "%.2f", statistic.rating)) %"
        countTrivia.text = "\(statistic.completed)"
        countAnswered.text = "\(statistic.answered)"
        countCorrect.text = "\(statistic.correct)"
    }

}
