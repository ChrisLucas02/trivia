//
//  Question.swift
//  Trivia
//
//  Created by Chris Lucas on 11.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit

class Question: Decodable {
    var category: String
    var type: String
    var difficulty: String
    var question: String
    var correct_answer: Int
    var given_answer: Int
    var answers: [String]
    var correct: Bool {
        return correct_answer == given_answer
    }
    
    // Used to create a new Question fetched from the local database (with answers and givenAnser)
      init(category: String, type: String, difficulty: String, question: String, correctAnswer: Int, givenAnswer: Int, answers: [String]) {
          self.category = category
          self.type = type
          self.difficulty = difficulty
          self.question = question
          self.correct_answer = correctAnswer
          self.given_answer = givenAnswer
          self.answers = answers
      }
      
      // Used to create a new Question fetched from the server
      convenience init(category: String, type: String, difficulty: String, question: String, correctAnswer: Int, answers: [String]) {
          self.init(category: category, type: type, difficulty: difficulty, question: question, correctAnswer: correctAnswer, givenAnswer: -1, answers: answers)
      }
      
      // Used to create a Question from json data
      required convenience init(from decoder: Decoder) throws {
          let container = try decoder.container(keyedBy: CodingKeys.self)
          let category = try container.decode(String.self, forKey: .category)
          let type = try container.decode(String.self, forKey: .type)
          let difficulty = try container.decode(String.self, forKey: .difficulty)
          let question = try container.decode(String.self, forKey: .question)
          let correctAnswer = try container.decode(String.self, forKey: .correctAnswer)
          var answers = try container.decode([String].self, forKey: .incorrectAnswers)
          let correctIndex = Int.random(in: 0..<TriviaRepository.shared.getNbAnswers())
          answers.insert(correctAnswer, at: correctIndex)
          answers = answers.map { $0.html2String }
          
          self.init(category: category.html2String,
                    type: type.html2String,
                    difficulty: difficulty.html2String,
                    question: question.html2String,
                    correctAnswer: correctIndex,
                    answers: answers)
      }
    
    enum CodingKeys: String, CodingKey {
        case category = "category"
        case type = "type"
        case difficulty = "difficulty"
        case question = "question"
        case correctAnswer = "correct_answer"
        case incorrectAnswers = "incorrect_answers"
    }
}

