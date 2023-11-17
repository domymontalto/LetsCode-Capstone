//
//  TestView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/13/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @Binding var navigationPath: NavigationPath
    
    @State var selectedAnswerIndex:Int?
    @State var submitted = false
    @State var showResults = false
     
    var body: some View {
        
        
        var buttonText:String {
            
            //Check if answer has been submitted
            if submitted == true {
                
                if model.currentQuestionIndex + 1 == model.currentModule?.test.totQuestions ?? 0 {
                    
                    //This is the last question
                    return "Finish"
                } else {
                    
                    //There is a next question
                    return "Next"
                }
                
            } else {
                
                return "Submit"
                
            }
            
            
        }
        
        
        if model.currentQuestion != nil && showResults == false {
            
            VStack(alignment: .leading) {
                
                //Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.totQuestions ?? 0)")
                    .padding(.leading, 20)
                
                
                //Question
                CodeTextView()
                    .padding(.horizontal, 20)
                
                //Answers
                ScrollView {
                    
                    VStack {
                        
                        ForEach(0..<model.currentQuestion!.answers.count, id: \.self) { index in
                            
                            Button {
                                
                                //Track the selected index
                                selectedAnswerIndex = index
                                
                            } label: {
                                
                                ZStack {
                                    
                                    if submitted == false {
                                        
                                        RectangleCard(color: index == selectedAnswerIndex ? .gray : .white)
                                            .frame(height: 48)
                                        
                                    } else {
                                        
                                        //Answer has been submitted
                                        if index == selectedAnswerIndex && index == model.currentQuestion!.correctIndex {
                                            
                                            //User has selected the right answer
                                            //Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                            
                                        }
                                        else if index == selectedAnswerIndex && index != model.currentQuestion!.correctIndex {
                                            
                                            //User has selected the wrong answer
                                            //Show a red background
                                            RectangleCard(color: .red)
                                                .frame(height: 48)
                                            
                                        }
                                        else if index == model.currentQuestion!.correctIndex {
                                            
                                            //This button is the correct answer
                                            //Show a green background
                                            RectangleCard(color: .green)
                                                .frame(height: 48)
                                            
                                        } else {
                                            
                                            RectangleCard(color: .white)
                                                .frame(height: 48)
                                        }
                                    }
                                    
                                    Text(model.currentQuestion!.answers[index])
                                    
                                }
                                
                            }
                            .disabled(submitted)
                            
                            
                        }
                    }
                    .padding()
                    .buttonStyle(.plain)
                    
                }
                
                //Submit Button
                Button {
                    
                    //Check if answer has been submitted
                    if submitted == true {
                        
                        //Check if it was the last question
                        if model.currentQuestionIndex + 1 == model.currentModule!.test.totQuestions {
                            
                            //Check next question and save progress
                            model.nextQuestion()
                            
                            showResults = true

                        } else {
                            
                            //Answer has already been submitted, move to next question, saving progress
                            model.nextQuestion()
                            
                            //Reset properties
                            submitted = false
                            selectedAnswerIndex = nil
                        }
                    }
                    else {
                        //Submit the answer
                        
                        //Change submitted state to true
                        submitted = true
                        
                        //Check the answer and increment the count if correct
                        if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                            
                            model.numCorrect! += 1
                        }
                        
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text(buttonText)
                            .foregroundStyle(Color(.white))
                            .fontWeight(.bold)
                        
                    }
                    .padding()
                    
                }
                .disabled(selectedAnswerIndex == nil)
                .buttonStyle(.plain)

                
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")

        } else if showResults == true {
            
            //Check if we already earned this lesson's Award
            let isAwardAlreadyEarned = model.isAwardAlreadyEarned()
            
            //If showResults is true we show ther result view
            TestResultView(navigationPath: $navigationPath, isAwardAlreadyEarned: isAwardAlreadyEarned)
            
        } else {
            
            ProgressView()
        }
    }
}

//#Preview {
//    TestView()
//}
