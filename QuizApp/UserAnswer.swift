//
//  UserAnswer.swift
//  QuizApp
//
//  Created by Kevin Rohwer on 18.09.24.
//

import Foundation

struct UserAnswer: Identifiable {
    let id = UUID()
    let question: String
    let correctAnswer: String
    let userAnswer: String
    let isCorrect: Bool
}
