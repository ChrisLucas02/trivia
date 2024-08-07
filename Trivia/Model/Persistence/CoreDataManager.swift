//
//  CoreDataManager.swift
//  Trivia
//
//  Created by Chris Lucas on 25.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit
import CoreData

class CoreDataManager: NSObject {
    static let shared = CoreDataManager()
        
    private var context: NSManagedObjectContext?
    
    private var entityName: String?
    
    private var questions:[Question] = []
    
    override init() {
        context = persistentContainer.viewContext
        entityName = "Questions"
    }
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Trivia")
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to load persitent store \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    
    func save(quest: Question) {
        let entity = NSEntityDescription.entity(forEntityName: entityName!, in: context!)
        let question = NSManagedObject(entity: entity!, insertInto: context)
        question.setValue(quest.question, forKey: "question")
        question.setValue(quest.category, forKey: "category")
        question.setValue(quest.correct_answer, forKey: "correct_answer")
        question.setValue(quest.difficulty, forKey: "difficulty")
        question.setValue(quest.given_answer, forKey: "given_answer")
        question.setValue(quest.type, forKey: "type")
        question.setValue(quest.answers, forKey: "answers")

        do {
            try context!.save()
        } catch let error as NSError {
            print("Couldn't save. \(error), \(error.userInfo)")
        }
    }
    
    func fetchQuestions() -> [Question]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName!)
        do {
            self.questions = try context!.fetch(fetchRequest).map{$0.toQuestion()}.reversed()
        } catch let error as NSError {
            print("Couldn't save. \(error), \(error.userInfo)")
        }
        return self.questions
    }
}

extension NSManagedObject {
    func toQuestion() -> Question {
        return Question(category: value(forKey: "category") as! String, type: value(forKey: "type") as! String, difficulty: value(forKey: "difficulty") as! String, question: value(forKey: "question") as! String, correctAnswer: value(forKey: "correct_answer") as! Int, givenAnswer: value(forKey: "given_answer") as! Int, answers: value(forKey: "answers") as! [String])
    }
}
