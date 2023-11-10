//
//  ResumeView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/3/23.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @Binding var navigationPath: NavigationPath
    
    @Binding var showLessons: Bool
    @Binding var showTest: Bool
    @Binding var resumeLessons: Bool
    @Binding var resumeTest: Bool
    
    let user = UserService.shared.user
    
    var resumeTitle: String {
        
        let module = model.modules[user.lastModule ?? 0]
        
        if user.lastLesson != 0 {
            //Resume a lesson
            return "Learn \(module.category): Lesson \(user.lastLesson! + 1)"
            
        } else {
            //Resume a test
            return "\(module.category) Test: Question \(user.lastQuestion! + 1)"
        }
        
    }
    
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        Group {
            
            if user.lastLesson! > 0 {
                
                Button {
                    
                    //Preparing for ContentDetailView
                    model.getLessons(module) {
                        model.beginModule(module.id)
                        
                        navigationPath.append(module)
                        
                        resumeLessons = true
                        showLessons = false
                        showTest = false
                        resumeTest = false
                        
                    }
                    
                } label: {
                    
                    ResumeCard(resumeTitle: resumeTitle)
                }
                
            } else {
                
                Button {
                    
                    //Preparing for TestView
                    model.getQuestions(module) {
                        model.beginTest(module.id)
                        //Restart from the user's last question
                        model.currentQuestionIndex = user.lastQuestion!
                        model.resumeQuestion()
                        
                        navigationPath.append(module)
                        
                        resumeTest = true
                        showLessons = false
                        showTest = false
                        resumeLessons = false
                        
                    }
                    
                } label: {
                    
                    ResumeCard(resumeTitle: resumeTitle)
                }

                
            }
        }
        
    }
    
    
}

//#Preview {
//    ResumeView()
//}
