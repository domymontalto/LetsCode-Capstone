//
//  TestView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/13/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var selectedAnswerIndex:Int?
    @State var numCorrect = 0
    @State var submitted = false
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
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
                    
                    //Change submitted state to true
                    submitted = true
                    
                    //Check the answer and increment the count if correct
                    
                    if selectedAnswerIndex == model.currentQuestion!.correctIndex {
                        
                        numCorrect += 1
                    }
                    
                } label: {
                    
                    ZStack {
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            
                        
                        
                    }
                    .padding()
                    
                }
                .disabled(selectedAnswerIndex == nil)
                .buttonStyle(.plain)

                
                
            }
            .navigationTitle("\(model.currentModule?.category ?? "") Test")

        } else {
            
            //Test hasn't loaded yet
            ProgressView()
            
        }
        
    }
}

#Preview {
    TestView()
}
