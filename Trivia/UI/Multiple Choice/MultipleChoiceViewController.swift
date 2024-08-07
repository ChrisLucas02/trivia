//
//  MultipleChoiceViewController.swift
//  Trivia
//
//  Created by Chris Lucas on 14.08.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine

class MultipleChoiceViewController: UIViewController {
    
    // MARK: - Attributes
    
    @IBOutlet weak var category: UILabel!           // label of the selected category
    @IBOutlet weak var difficulty: UILabel!         // label of the question difficulty
    @IBOutlet weak var question: UILabel!           // label of the question itself
    @IBOutlet weak var answer1: UIButton!           // label of the first possible answer
    @IBOutlet weak var answer2: UIButton!           // label of the second possible answer
    @IBOutlet weak var answer3: UIButton!           // label of the third possible answer
    @IBOutlet weak var answer4: UIButton!           // label of the fourth possible answer
    @IBOutlet weak var card1: UIView!               // card effect of the first answer
    @IBOutlet weak var card2: UIView!               // card effect of the second answer
    @IBOutlet weak var card3: UIView!               // card effect of the third answer
    @IBOutlet weak var card4: UIView!               // card effect of the fourth answer
    @IBOutlet weak var cardDifficulty: UIView!      // card effect of the question difficuly
    @IBOutlet weak var gameView: UIView!            // contains the whole question information, can be used to hide all views while the data is downloaded from internet
    @IBAction private func timeFinished() {
        let end:Bool! = self.viewModel.fetchNextQuestion()
        self.resetUI()
        if end {
            self.performSegue(withIdentifier: "resultSegue", sender: self)

        }
    }
    // TODO: - To complete
    var idCategory:Int?
    var replayQuestion:Question?
    private var tableLoadingView: LoadingView!
    private var viewModel:MultipleChoiceViewModel = MultipleChoiceViewModel()
    private var subcriptions: Set<AnyCancellable> = []

    
    // MARK: - IBActions
    
    @IBAction func answerClicked(_ sender: UIButton) {
        // TODO: - To complete
        let question: Question! = viewModel.checkQuestion(id: sender.tag)
        if (question.correct) {
            changeColor(color: UIColor.green, id: sender.tag)
            viewModel.incrementScore()
        } else {
            changeColor(color: UIColor.green, id: question.correct_answer)
            changeColor(color: UIColor.red, id: sender.tag)
        }
        Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(timeFinished), userInfo: nil, repeats: false)
    }
    
    
    // MARK: - UIViewController overrides
    override func viewDidDisappear(_ animated: Bool) {
        self.subcriptions.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addElevation(card: card1)
        addElevation(card: card2)
        addElevation(card: card3)
        addElevation(card: card4)
        addElevation(card: cardDifficulty)

        if replayQuestion == nil {
            showCustomBackButton()
            setupView()
            bindViewModel()
            viewModel.fetchQuestions(idCategory: idCategory!)
        } else {
            self.title = "Replay"
            self.category.text = replayQuestion?.category
            self.difficulty.text = replayQuestion?.difficulty
            self.question.text = replayQuestion?.question
            self.answer1.setTitle(replayQuestion?.answers[0], for: .normal)
            self.answer2.setTitle(replayQuestion?.answers[1], for: .normal)
            self.answer3.setTitle(replayQuestion?.answers[2], for: .normal)
            self.answer4.setTitle(replayQuestion?.answers[3], for: .normal)
            self.enableAnswers(bool: false)
            self.changeColor(color: UIColor.green, id: self.replayQuestion!.correct_answer)
            if !(self.replayQuestion!.correct){
                self.changeColor(color: UIColor.red, id: self.replayQuestion!.given_answer)
            }
            chooseDiffColor(difficulty: self.replayQuestion!.difficulty)
        }
    }

    
    
    // MARK: - Private methods
    
    private func setupView(){
        self.tableLoadingView = LoadingView(superView: self.view, navigationController: self.navigationController, label: "Loading...")
        self.tableLoadingView.showLoadingView()
        hideElement(bool: true)
    }
    
    private func bindViewModel(){
        viewModel.$title.assign(to: \.title, on:self).store(in: &subcriptions)
        viewModel.$category.assign(to: \.text, on:category).store(in: &subcriptions)
        viewModel.$difficulty.sink(receiveValue: { value in
            self.difficulty.text = value
            switch value{
                case "easy":
                    self.cardDifficulty.backgroundColor = UIColor.green
                case "medium":
                    self.cardDifficulty.backgroundColor = UIColor.orange
                case "hard":
                    self.cardDifficulty.backgroundColor = UIColor.red
                default: break
            }
        }).store(in: &subcriptions)
        viewModel.$question.assign(to: \.text, on:question).store(in: &subcriptions)
        viewModel.$answers.sink(receiveValue: { result in
            if (((result?.isEmpty) != nil) && (result?.count == 4)) {
                self.answer1.setTitle(result?[0], for: .normal)
                self.answer2.setTitle(result?[1], for: .normal)
                self.answer3.setTitle(result?[2], for: .normal)
                self.answer4.setTitle(result?[3], for: .normal)
                self.tableLoadingView.hideLoadingView()
                self.hideElement(bool: false)
            }
        }).store(in: &subcriptions)
    }
    
    // create a card-like looking component on the given view
    private func addElevation(card: UIView) {
        card.layer.shadowColor = UIColor.gray.cgColor
        card.layer.shadowOpacity = 1
        card.layer.shadowOffset = .zero
        card.layer.shadowRadius = 3
        card.layer.shouldRasterize = true
    }
    
    // enable (true) or disable (false) the ability to clic on the button
    private func enableAnswersUserInteraction(enable: Bool) {
        let answers = [answer1, answer2, answer3, answer4]
        for answer in answers {
            answer?.isUserInteractionEnabled = enable
        }
    }
    
    private func hideElement(bool: Bool) {
        self.card1.isHidden = bool
        self.card2.isHidden = bool
        self.card3.isHidden = bool
        self.card4.isHidden = bool
        self.cardDifficulty.isHidden = bool
    }
    
    private func enableAnswers(bool: Bool) {
        self.answer1.isEnabled = bool
        self.answer2.isEnabled = bool
        self.answer3.isEnabled = bool
        self.answer4.isEnabled = bool
    }
    
    private func changeColor(color: UIColor, id: Int) {
        enableAnswers(bool: false)
        switch id {
            case 0:
                self.card1.backgroundColor = color
            case 1:
                self.card2.backgroundColor = color
            case 2:
                self.card3.backgroundColor = color
            case 3:
                self.card4.backgroundColor = color
            default:
                print("Trying again")//do nothing
        }
    }
    private func chooseDiffColor(difficulty:String) {
        switch difficulty {
            case "easy":
                self.cardDifficulty.backgroundColor = UIColor.green
            case "medium":
                self.cardDifficulty.backgroundColor = UIColor.orange
            case "hard":
                self.cardDifficulty.backgroundColor = UIColor.red
            default: break
        }
    }
    
    private func resetUI() {
        enableAnswers(bool: true)
        self.card1.backgroundColor = UIColor.white
        self.card2.backgroundColor = UIColor.white
        self.card3.backgroundColor = UIColor.white
        self.card4.backgroundColor = UIColor.white
    }
    
    private func showCustomBackButton() {
        self.navigationItem.hidesBackButton = true
        let backButton = getCustomBackButton(title: "Trivia")
        backButton.addTarget(self, action: #selector(self.onBackPressed(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @IBAction private func onBackPressed(_ sender: UIButton) {
        viewModel.resetGame()
        self.dismiss(animated: false, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
