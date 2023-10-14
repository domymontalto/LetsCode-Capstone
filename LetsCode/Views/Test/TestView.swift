//
//  TestView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/13/23.
//

import SwiftUI

struct TestView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        
        if model.currentQuestion != nil {
            
            VStack {
                
                //Question number
                Text("Question \(model.currentQuestionIndex + 1) of \(model.currentModule?.test.totQuestions ?? 0)")
                
                
                //Question
                CodeTextView()
                
                //Answers
                
                //Button
                
                
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
