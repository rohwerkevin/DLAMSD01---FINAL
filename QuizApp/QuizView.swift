//
//  QuizAppApp.swift
//  QuizApp
//
//  Created by Kevin Rohwer on 18.09.24.
//
import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: QuizViewModel

    // Funktion zur Bestimmung des Spruchs und Symbols
    func getCompletionMessage() -> (text: String, symbolName: String)? {
        let totalQuestions = viewModel.questions.count
        let score = viewModel.score

        if score == totalQuestions {
            return ("Perfekt! Alle Antworten sind richtig!", "star.fill")
        } else if score >= 15 {
            return ("Großartig! Du hast \(score) von \(totalQuestions) richtig!", "trophy.fill")
        } else if score >= 10 {
            return ("Gut gemacht! Du hast \(score) von \(totalQuestions) richtig!", "hand.thumbsup.fill")
        } else if score >= 5 {
            return ("Nicht schlecht! Du hast \(score) von \(totalQuestions) richtig!", "lightbulb.fill")
        } else {
            return ("Versuche es erneut, du kannst es besser!", "lightbulb")
        }
    }

    var body: some View {
        ZStack {
            // Hintergrund mit Farbverlauf
            LinearGradient(gradient: Gradient(colors: [Color.orange, Color.red]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.showFinalScore {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Quiz beendet!")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundColor(.white)
                                .shadow(radius: 10)

                            // Anzeige des Punktestands
                            Text("Dein Punktestand: \(viewModel.score) von \(viewModel.questions.count)")
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()

                            // Anzeige des Spruchs und Symbols
                            if let message = getCompletionMessage() {
                                HStack(alignment: .center, spacing: 10) {
                                    Image(systemName: message.symbolName)
                                        .font(.system(size: 40))
                                        .foregroundColor(.yellow)
                                    Text(message.text)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                }
                                .padding()
                            }

                            // Zusammenfassung der Fragen und Antworten
                            ForEach(Array(viewModel.userAnswers.enumerated()), id: \.element.id) { index, answer in
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        Text("Frage \(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                        Spacer()
                                        Image(systemName: answer.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(answer.isCorrect ? .green : .red)
                                    }

                                    VStack(alignment: .leading, spacing: 10) {
                                        Text(answer.question)
                                            .font(.body)
                                            .foregroundColor(.white)
                                            .fixedSize(horizontal: false, vertical: true)

                                        HStack(alignment: .top) {
                                            Text("Deine Antwort:")
                                                .fontWeight(.semibold)
                                                .foregroundColor(.white)
                                            Text(answer.userAnswer)
                                                .foregroundColor(answer.isCorrect ? .green : .red)
                                        }

                                        if !answer.isCorrect {
                                            HStack(alignment: .top) {
                                                Text("Richtige Antwort:")
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.white)
                                                Text(answer.correctAnswer)
                                                    .foregroundColor(.green)
                                            }
                                        }
                                    }
                                }
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                                )
                            }

                            Button(action: {
                                viewModel.restartQuiz()
                            }) {
                                Text("Erneut versuchen")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)
                        }
                        .padding()
                    }
                } else {
                    ScrollView {
                        VStack(spacing: 20) {
                            if viewModel.currentQuestionIndex < viewModel.questions.count {
                                let currentQuestion = viewModel.questions[viewModel.currentQuestionIndex]

                                VStack(alignment: .leading, spacing: 20) {
                                    Text("Frage \(viewModel.currentQuestionIndex + 1) von \(viewModel.questions.count)")
                                        .font(.headline)
                                        .foregroundColor(.white)

                                    Text(currentQuestion.question)
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.leading)
                                        .padding()
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(10)

                                    // Eingabefeld für die Antwort
                                    TextField("Deine Antwort", text: $viewModel.userAnswer)
                                        .padding()
                                        .background(Color.white)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                        .padding(.bottom, 10)

                                    // Button zum Überprüfen der Antwort
                                    Button(action: {
                                        viewModel.checkAnswer()
                                    }) {
                                        Text("Antwort bestätigen")
                                            .font(.headline)
                                            .padding()
                                            .frame(maxWidth: .infinity)
                                            .background(Color.blue)
                                            .foregroundColor(.white)
                                            .cornerRadius(15)
                                            .shadow(radius: 5)
                                    }
                                    .disabled(viewModel.userAnswer.isEmpty)

                                    // Anzeige des Ergebnisses (richtig/falsch)
                                    if let showResult = viewModel.showResult {
                                        Text(showResult ? "Richtig!" : "Falsch!")
                                            .font(.headline)
                                            .foregroundColor(showResult ? .green : .red)
                                            .padding()
                                    }

                                    // Punktestand
                                    Text("Punkte: \(viewModel.score)")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                }
                                .padding()
                            } else {
                                Text("Keine Fragen verfügbar.")
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden(viewModel.showFinalScore)
        }
    } 
}
