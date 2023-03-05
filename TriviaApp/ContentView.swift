//
//  ContentView.swift
//  TriviaApp
//
//  Created by Jared on 3/3/23.
//

import SwiftUI

// TODO: Have a backup JSON in case user is offline
// TODO: Prevent repeat questions (UserDefaults?)
// TODO: Filter by category
// TODO: Add screen for selecting categories, difficulty, etc
// TODO: Add launch screen
// TODO: Add fade-in/out transition between questions

struct ContentView: View {
    // Sample values for building purposes:
    @State private var incorrectAnswers: [String] = ["Incorrect 1", "Incorrect 2", "Incorrect 3"]
    @State private var correctAnswer: String = "Correct"
    @State private var questionText: String = "Sample question text"
    
    // Determine if player can answer question
    @State private var questionAnswered: Bool = false
    
    @State private var shuffledModules: [AnswerModule] = []
    @State private var selectedAnswer: AnswerModule?
    
    @State private var userScore: Int = 0
    @State private var totalScore: Int = 0
    @State private var questionNumber: Int = 0
    
    @State private var lineWidth: Double = 0
    
    @State private var buttonText: String = "Skip 􀊌"
    
    let questions: [String: JSONQuestion] = Bundle.main.decode("questions.json")
    
    // TODO: Call API to retrieve question bank if online
    //        func getTriviaQuestions(completion:@escaping ([AnswerModule]) -> ()) {
    //            guard let url = URL(string: "\(APIURL)") else { return }
    //
    //            URLSession.shared.dataTask(with: url) { (data, _, _) in
    //                let questions = try! JSONDecoder().decode([AnswerModule].self, from: data!)
    //
    //                DispatchQueue.main.async {
    //                    completion(questions)
    //                }
    //            }
    //            .resume()
    //        }
    
    func generateQuestion() {
        
        // Reset UI
        buttonText = "Skip"
        lineWidth = 0.0
        questionAnswered = false
        selectedAnswer = nil
        
        // Load next question
        questionNumber += 1
        if let currentQuestion = questions.values.randomElement() {
            incorrectAnswers = currentQuestion.incorrectAnswers
            correctAnswer = currentQuestion.correctAnswer
            questionText = currentQuestion.question
        }
        let allModules = generateModules(correctAnswer: correctAnswer, incorrectAnswers: incorrectAnswers)
        shuffledModules = allModules.shuffled()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background fill
                LinearGradient(colors: [.pink, .blue], startPoint: .topTrailing, endPoint: .bottomLeading)
                    .ignoresSafeArea()
                
                // Question text
                VStack {
                    VStack {
                        Text("Question \(questionNumber)")
                            .font(.title2.bold())
                        Divider()
                        Text(questionText)
                    }
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    Spacer()
                    
                    // Button stack
                    ForEach(shuffledModules, id: \.self) { answerModule in
                        Button(action: {
                            // Return if user already answered
                            guard !questionAnswered else { return }
                            selectedAnswer = answerModule;
                            questionAnswered = true
                            if answerModule.correct { userScore += 1 }
                            totalScore += 1
                            withAnimation { lineWidth = 3; buttonText = "Next" }
                        })
                        {
                            Text("\(answerModule.answer)")
                                .fontWeight(Font.Weight.semibold)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.primary)
                        }
                        .background(selectedAnswer == answerModule ? answerModule.color : Color.clear)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(answerModule.color, lineWidth: lineWidth)
                        )
                    }
                }
                .navigationTitle("\(userScore) / \(totalScore)")
                .navigationBarTitleDisplayMode(.inline)
                .frame(maxWidth: UIScreen.main.bounds.width * 0.9)
                .padding()
                .onAppear(perform: generateQuestion)
                .toolbar {
                    Button(action: generateQuestion) {
                        HStack {
                            Text(buttonText)
                            Image(systemName: "forward.fill")
                        }
                        .fixedSize()
                        .padding(10)
                        .background(.thinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
