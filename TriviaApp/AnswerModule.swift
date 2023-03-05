//
//  AnswerModule.swift
//  TriviaApp
//
//  Created by Jared on 3/5/23.
//

import SwiftUI

struct AnswerModule: Codable, Hashable {
    let answer: String
    let correct: Bool
    var color: Color {
        correct ? Color.green : Color.red
    }
}

func generateModules(correctAnswer: String, incorrectAnswers: [String]) -> [AnswerModule] {
    [
        AnswerModule(answer: correctAnswer, correct: true),
        AnswerModule(answer: incorrectAnswers[0], correct: false),
        AnswerModule(answer: incorrectAnswers[1], correct: false),
        AnswerModule(answer: incorrectAnswers[2], correct: false),
    ]
}
