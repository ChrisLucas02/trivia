//
//  ResultViewController.swift
//  Trivia
//
//  Created by Chris Lucas on 14.08.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine

class ResultViewController: UIViewController {
    
    // MARK: - Attributes
    @IBOutlet weak var medal: UIImageView!          // image of the medal won
    @IBOutlet weak var textMedal: UILabel!          // medal description (like: "well done")
    @IBOutlet weak var score: UILabel!              // obtained score
    
    private var viewModel:ResultViewModel = ResultViewModel()
    private var subcriptions: Set<AnyCancellable> = []
    
    // MARK: - UIViewController overrides
    override func viewDidDisappear(_ animated: Bool) {
        self.subcriptions.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCustomBackButton()
        viewModel.determineMedal()
        score.text = "\(viewModel.getScore()) / \(viewModel.getNbQuestions())"
        viewModel.$message.assign(to: \.text, on:textMedal).store(in: &subcriptions)
        viewModel.$medal.sink { type in
            if type != nil {
                switch type! {
                    case MedalType.Fail:
                        self.medal.image = UIImage(named: "MedalFail")
                    case MedalType.Bronze:
                        self.medal.image = UIImage(named: "MedalBronze")
                    case MedalType.Silver:
                        self.medal.image = UIImage(named: "MedalSilver")
                    case MedalType.Gold:
                        self.medal.image = UIImage(named: "MedalGold")
                }
            }

        }.store(in: &subcriptions)
        viewModel.saveStats()
    }
    

    // MARK: - Navigation
    
    private func showCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = getCustomBackButton(title: "Trivia")
        backButton.addTarget(self, action: #selector(self.onBackPressed(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction private func onBackPressed(_ sender: UIButton) {
        viewModel.resetGame()
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popToRootViewController(animated: true)
    }

}
