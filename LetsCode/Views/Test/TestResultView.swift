//
//  TestResultView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/18/23.
//

import SwiftUI

struct TestResultView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @Binding var navigationPath: NavigationPath
    
    @State var updateAwards = false
    @State var isAwardAlreadyEarned : Bool
    @State var user = UserService.shared.user
    
    var resultHeading: String {
        
        guard model.currentModule != nil else {
            return ""
        }
        
        let pct = Double(model.numCorrect!)/Double(model.currentModule!.test.totQuestions)
        
        if pct >= 0.8 {
            
            //Update Awards if pct is at least 80%
            DispatchQueue.main.async {
                updateAwards = true
            }
            
            return "Awesome!"
        } else if pct >= 0.5 {
            return "Doing great!"
        } else {
            return "Keep learning."
        }
        
    }
    
    var body: some View {
        
        VStack {
            
            Spacer()
            
            Text(resultHeading)
                .font(.title)
                .padding(.bottom, 20)
            
            //Tell the user they earned a new Award and display Award Image if they haven't already earned that Award
            if !isAwardAlreadyEarned {
                
                Text("You earned a new Award!!!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Image(model.currentModule?.category ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .padding()
            }
            
            Spacer()
            
            Text("You got \(model.numCorrect!) out of \(model.currentModule?.test.totQuestions ?? 0) questions")
            
            Spacer()
            
            Button {
                
                //Update the Awards if user got at least 80% of score and they didn't earned this award already
                if updateAwards == true {
                    
                    if !isAwardAlreadyEarned {
                        
                        model.updateAwards()
                    }
                }
                
                updateAwards = false
                
                //Send the user back to the home view
                navigationPath.removeLast(navigationPath.count)
                
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
            
        }
    }
}

//#Preview {
//    TestResultView()
//}
