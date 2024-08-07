//
//  MultipleChoiceViewModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import Foundation
import Combine

class MultipleChoiceViewModel : ObservableObject {
    @Published private(set) var category:String?
    @Published private(set) var type:String?
    @Published private(set) var difficulty:String?
    @Published private(set) var question:String?
    @Published private(set) var answers:[String]?
    
    @Published private(set) var endgame:Bool = false
    @Published private(set) var title:String?
    
    var questions = CurrentValueSubject<[Question], Never>([Question]())
    let nbQuestions = TriviaRepository.shared.getNbQuestions()
    
    private var subscriptions:Set<AnyCancellable> = []
    
    init() {
        fetchQuestion()
        getTitle()
    }
    
    func fetchQuestions(idCategory:Int){
        TriviaRepository.shared.getQuestions(idCategory: idCategory)
    }
    
    func fetchQuestion(){
        TriviaRepository.shared.$question.sink { [unowned self] curr_question in
            if curr_question != nil {
                self.category = curr_question?.category
                self.question = curr_question?.question
                self.type = curr_question?.type
                self.difficulty = curr_question?.difficulty
                self.answers = curr_question?.answers
            }
        }.store(in: &subscriptions)
    }
    
    func fetchNextQuestion() -> Bool{
        self.answers = []
        TriviaRepository.shared.getNextQuestion()
        return TriviaRepository.shared.endgame
    }
    
    func checkQuestion(id: Int) -> Question {
        TriviaRepository.shared.getQuestion().given_answer = id
        return TriviaRepository.shared.getQuestion()
    }
    
    func resetGame() {
        TriviaRepository.shared.resetGame()
    }
    
    func getTitle() {
        TriviaRepository.shared.$currQuestion.sink { newValue in
            self.title = "Question \(newValue+1) / \(self.nbQuestions)"
        }.store(in: &subscriptions)
    }
    
    func incrementScore() {
        TriviaRepository.shared.score += 1
    }
}
