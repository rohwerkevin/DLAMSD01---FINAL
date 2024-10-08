//
//  Question.swift
//  QuizApp
//
//  Created by Kevin Rohwer on 18.09.24.
//

import Foundation

struct Question: Codable, Identifiable {
    let id: UUID = UUID()
    let question: String
    let answer: String
    
    private enum CodingKeys: String, CodingKey {
        case question
        case answer
    }
}





