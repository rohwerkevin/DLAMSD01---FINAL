//
//  QuizViewModel.swift
//  QuizApp
//
//  Created by Kevin Rohwer on 18.09.24.
//

import Foundation
import Combine

class QuizViewModel: ObservableObject {
    @Published var currentQuestionIndex = 0
    @Published var userAnswer = ""
    @Published var score = 0
    @Published var showResult: Bool?
    @Published var showFinalScore = false
    @Published var questions: [Question] = []
    @Published var userAnswers: [UserAnswer] = []
    
    let difficulty: GameDifficulty
    
    init(difficulty: GameDifficulty) {
        self.difficulty = difficulty
        loadQuestions()
    }
    
    // Fragenkatalog in die App laden
    func loadQuestions() {
        if let url = Bundle.main.url(forResource: "questions", withExtension: "json") {
            print("questions.json gefunden.")
            do {
                let data = try Data(contentsOf: url)
                let allQuestions = try JSONDecoder().decode([String: [Question]].self, from: data)
                
                if let questionsForDifficulty = allQuestions[difficulty.rawValue] {
                    questions = questionsForDifficulty
                    print("Anzahl der geladenen Fragen: \(questions.count) ,Schwierigkeit: \(difficulty.rawValue)")
                    questions.shuffle()
                } else {
                    print("Keine Fragen für den Schwierigkeitsgrad \(difficulty.rawValue) gefunden.")
                }
            } catch {
                print("Fehler beim Laden der Fragen: \(error)")
            }
        } else {
            print("questions.json nicht gefunden.")
        }
    }

    // Funktion zum überprüfen der Nutzerantworten

    func checkAnswer() {
        let currentQuestion = questions[currentQuestionIndex]
        let trimmedUserAnswer = userAnswer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedCorrectAnswer = currentQuestion.answer.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let isCorrect = trimmedUserAnswer == trimmedCorrectAnswer
        
        if isCorrect {
            score += 1
            showResult = true
        } else {
            showResult = false
        }
        
        // Antwort des Benutzers speichern
        let answerRecord = UserAnswer(
            question: currentQuestion.question,
            correctAnswer: currentQuestion.answer,
            userAnswer: userAnswer,
            isCorrect: isCorrect
        )
        userAnswers.append(answerRecord)
        
        // Nächste Frage oder Quiz beenden
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showResult = nil
            self.userAnswer = ""
            self.currentQuestionIndex += 1
            if self.currentQuestionIndex >= self.questions.count {
                self.showFinalScore = true
            }
        }
    }
    
    // Neustarten und zurücksetzen des Quizzes
    func restartQuiz() {
        currentQuestionIndex = 0
        score = 0
        userAnswer = ""
        showResult = nil
        showFinalScore = false
        userAnswers = []
        loadQuestions()
    }
}
