//
//  TriviaModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.09.20.
//  Copyright © 2020 HEIA-FR INFO. All rights reserved.
//

import Foundation
import Combine

// Class containing the whole logic and data to manage the trivia game
// TODO: make sure back button downloads a new question
// TODO: Set page title with question number
class TriviaRepository {
    
    // MARK: - Singleton
    static var shared = TriviaRepository()
    
    init() {
        categories = loadCategories()
    }
    
    
    // MARK: - Constants and attributes
    let goldMedal = 0.8             // threshold to win gold
    let silverMedal = 0.6           // threshold to win silver
    let bronzeMedal = 0.4           // threshold to win bronze
    let countdown = 1.5             // timer between two questions
    let nbQuestions:Int = 5
    let nbAnswers:Int = 3
    let type:String = QuestionType.multipleChoice.rawValue
    
    var endgame:Bool = false
    var score:Int = 0
    
    @Published var currQuestion: Int = 0
    @Published var questions:[Question] = []
    @Published var question:Question?
    @Published var medal:MedalType?
    @Published var message:String?
    
    private var subscriptions:Set<AnyCancellable> = []
    private var categories:Future<[Category], Error>?
    
    // MARK: - Singleton
    private var data = OnlineData.shared;
    
    // MARK: - Categories
    func getCategories() -> Future<[Category], Error>{
        return categories!
    }
    
    func loadCategories() -> Future<[Category], Error>{
       return data.downloadAllCategories()
    }
    
    //MARK: - Questions
    func getQuestions(idCategory:Int) {
        if questions.isEmpty {
            loadQuestions(idCategory: idCategory).sink { (completion) in
                print("fetchQuestions : \(completion)")
            } receiveValue: { [unowned self] result in
                questions = result
                question = result[currQuestion]
            }.store(in: &subscriptions)
        }
    }
    
    func loadQuestions(idCategory:Int)-> Future<[Question], Error>{
        return data.downloadQuestionOfCategory(nbQuestions: self.nbQuestions, type: self.type, id: idCategory)

    }
    
    func getNextQuestion() {
        CoreDataManager.shared.save(quest: TriviaRepository.shared.getQuestion())
        currQuestion += 1;
        if (currQuestion < nbQuestions) {
            question = questions[currQuestion]
        } else {
            endgame = true
            determineMedal()
        }
    }
    
    func getQuestion() -> Question {
        return question!
    }
    
    func getNbQuestions() -> Int{
        return nbQuestions
    }
    
    //MARK: - Logic Trivia
    func getNbAnswers() -> Int{
        return nbAnswers
    }
    
    func determineMedal() {
        let percent:Double = Double(self.score)/Double(self.nbQuestions)
        if percent >= self.goldMedal {
            medal = MedalType.Gold
            message = "Champion"
        } else if percent >= self.silverMedal {
            medal = MedalType.Silver
            message = "Pas mal..."
        } else if percent >= self.bronzeMedal {
            medal = MedalType.Bronze
            message = "Au moins t'as essayé"
        } else {
            medal = MedalType.Fail
            message = "Looser"
        }
    }
    
    func resetGame() {
        endgame = false
        score = 0
        currQuestion = 0
        questions = []
        question = nil
    }
    
    //MARK: - CoreData
    func saveStatistic() {
        let statistic:Statistic = StatisticData.shared.fetch()
        switch medal {
            case .Bronze:
                    statistic.nbBronze += 1
            case .Silver:
                    statistic.nbSilver += 1
            case .Gold:
                    statistic.nbGold += 1
            case .Fail: break
                    //do nothing
            case .none:break
        }
        statistic.completed += 1
        statistic.answered += nbQuestions
        statistic.correct += score
        StatisticData.shared.save(statistic: statistic)
    }
}

enum MedalType {
    case Fail, Bronze, Silver, Gold
}

enum Difficulty: String {
    case any = ""
    case easy = "easy"
    case medium = "medium"
    case hard = "hard"
}

enum QuestionType: String {
    case any = ""
    case multipleChoice = "multiple"
    case trueFalse = "boolean"
}
