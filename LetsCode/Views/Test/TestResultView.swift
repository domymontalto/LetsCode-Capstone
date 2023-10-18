//
//  TestResultView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/18/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    var numCorrect: Int
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(numCorrect)/Double(model.currentModule!.test.totQuestions)
        
        if pct >= 0.8 {
            return "Awesome!"
        } else if pct >= 0.5 {
            return "Doing great!"
        } else {
            return "Keep learning."
        }
        
    }
    
    var body: some View {
        
        
        VStack {
            
            Text(resultHeading)
                .font(.title)
            
            Spacer()
            
            Text("You got \(numCorrect) out of \(model.currentModule?.test.totQuestions ?? 0) questions")
            
            Spacer()
            
            Button {
                
                //Send the user back to the home view
                model.currentTestSelected = nil;
                
            } label: {
                
                
                ZStack {
                    
                    RectangleCard(color: .green)
                        .frame(height: 48)
                    
                    Text("Complete")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                }
                
            }
            .padding()
            
            Spacer()
            
        }
    }
}

//#Preview {
//    TestResultView()
//}
