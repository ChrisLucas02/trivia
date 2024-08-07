//
//  OnlineData.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import UIKit
import Combine

class OnlineData {
    
    static let shared = OnlineData()
    var cancellables = Set<AnyCancellable>()
        
    private init(){
    }
    
    func downloadAllCategories() -> Future<[Category], Error>{
        return Future<[Category], Error> { promise in
            let url = URL(string: "https://opentdb.com/api_category.php")
            URLSession.shared.dataTaskPublisher(for: url!)
                .subscribe(on: DispatchQueue.global(qos: .background))  // Execute download in background
                .receive(on: DispatchQueue.main)                        // Use main thread to give data
                .tryMap { (data, response) -> Data in                   // make sure url good and map data
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300 else {
                              throw URLError(.badServerResponse)
                        }
                    return data
                }
                .decode(type: TriviaCategories.self, decoder: JSONDecoder())    // Decode data to TriviaCategories
                .sink { completion in
                    print("Download Categories: \(completion)")
                } receiveValue: { (trivia) in
                    promise(.success(trivia.trivia_categories))
                }.store(in: &self.cancellables)
        }
    }

    func downloadQuestionOfCategory(nbQuestions:Int, type:String, id:Int) -> Future<[Question], Error>{
        return Future<[Question], Error> { promise in
            let url = URL(string: "https://opentdb.com/api.php?amount=\(nbQuestions)&category=\(id)&type=\(type)")
            URLSession.shared.dataTaskPublisher(for: url!)
                .subscribe(on: DispatchQueue.global(qos: .background))  // Execute download in background
                .receive(on: DispatchQueue.main)                        // Use main thread to give data
                .tryMap { (data, response) -> Data in                   // make sure url good and map data
                    guard
                        let response = response as? HTTPURLResponse,
                        response.statusCode >= 200 && response.statusCode < 300 else {
                              throw URLError(.badServerResponse)
                        }
                    return data
                }
                .decode(type: TriviaQuestions.self, decoder: JSONDecoder())    // Decode data to TriviaCategories
                .sink { completion in
                    print("Download Questions: \(completion)")
                } receiveValue: { (trivia) in
                    promise(.success(trivia.results))
                }.store(in: &self.cancellables)
        }
    }
}
