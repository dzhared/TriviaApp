//
//  JSONQuestion.swift
//  TriviaApp
//
//  Created by Jared on 3/4/23.
//

struct JSONQuestion: Codable, Identifiable {
    let id: String
    let category: String
    let question: String
    let incorrectAnswers: [String]
    let correctAnswer: String
}
