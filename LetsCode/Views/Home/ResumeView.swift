//
//  ResumeView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/3/23.
//

import SwiftUI

struct ResumeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @State var resumeSelected: Int?
    
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
    
    var destination: some View {
        
        
        return Group {
            
            var module = model.modules[user.lastModule ?? 0]
            
            //Determine if we need to go into a ContentDetailView or a TestView
            if user.lastLesson! > 0 {
                
                //Ge to ContentDetailView
                ContentDetailView(lessonIndex: 0)
                    .onAppear(perform: {
                        
                        //Fetch lessons
                        model.getLessons(module) {
                            model.beginModule(module.id)
                            model.beginLesson(user.lastLesson!)
                        }
                    })
                
            } else {
                
                //Go to testView
                TestView()
                    .onAppear(perform: {
                        
                        model.getQuestions(module) {
                            model.beginTest(module.id)
                            model.currentQuestionIndex = user.lastQuestion!
                            model.resumeQuestion()
                        }
                    })
            }
            
        }
        
    }
    
    
    var body: some View {
        
        let module = model.modules[user.lastModule ?? 0]
        
        NavigationLink(destination: destination,
                       tag: module.id.hash,
                       selection: $resumeSelected) {
            ZStack{
                
                RectangleCard()
                    .frame(height: 66)
                
                HStack{
                    
                    VStack(alignment: .leading){
                        
                        Text("Continue where you left off:")
                        
                        Text(resumeTitle)
                            .fontWeight(.bold)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "play.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                    
                }
                .foregroundStyle(Color(Color.black))
                .padding()
            }
            
        }
        
    }
    
    
}

#Preview {
    ResumeView()
}
