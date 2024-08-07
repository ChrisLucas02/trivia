//
//  CategoryTableViewModel.swift
//  Trivia
//
//  Created by Chris Lucas on 04.11.21.
//  Copyright © 2021 HEIA-FR INFO. All rights reserved.
//

import Foundation
import Combine

class CategoryTableViewModel: ObservableObject {
    
    var categories = CurrentValueSubject<[Category], Never>([Category]())
    private var cat_cancellables:Set<AnyCancellable> = []
    
    init() {
        self.fetchCategories()
    }
    
    func fetchCategories() {
        TriviaRepository.shared.getCategories().sink(receiveCompletion: { (completion) in
            print("fetchCategories : \(completion)")
        }, receiveValue: { [unowned self] result in
            self.categories.send(result)
        }).store(in: &cat_cancellables)
    }
}
