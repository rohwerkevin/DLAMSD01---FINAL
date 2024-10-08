//
//  GameDifficulty.swift
//  QuizApp
//
//  Created by Kevin Rohwer on 18.09.24.
//

import Foundation

enum GameDifficulty: String, CaseIterable, Identifiable {
    case easy = "Leicht"
    case medium = "Mittel"
    case hard = "Schwer"

    var id: String { self.rawValue }

    var iconName: String {
        switch self {
        case .easy:
            return "tortoise.fill"
        case .medium:
            return "hare.fill"
        case .hard:
            return "bolt.fill"
        }
    }
}
