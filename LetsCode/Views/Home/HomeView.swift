
//
//  ContentView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @State var navigationPath = NavigationPath()
    @State var showLessons = false
    @State var showTest = false
    @State var resumeLessons = false
    @State var resumeTest = false
    
    let user = UserService.shared.user
    
    var navTitle: String {
        
        if user.lastLesson != nil || user.lastQuestion != nil {
            
            return "Welcome Back"
            
        } else {
            
            return "Get Started"
        }
        
    }
    
    
    var body: some View {
        
        NavigationStack(path: $navigationPath) {
            
            VStack(alignment: .leading) {
                
                if user.lastLesson != nil && user.lastLesson! > 0 || user.lastQuestion != nil && user.lastQuestion! > 0 {
                    
                    //Show the resume view
                    ResumeView(navigationPath: $navigationPath, showLessons: $showLessons, showTest: $showTest, resumeLessons: $resumeLessons, resumeTest: $resumeTest)
                        .padding([.horizontal, .top])
                    
                } else {
                    
                    Text("What do you want to do today?")
                        .padding(.leading)
                }
                
                ScrollView(showsIndicators: false) {
                    
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                Button {
                                    
                                    //Preparing for ContentView
                                    model.getLessons(module) {
                                        model.beginModule(module.id)
                                        
                                        navigationPath.append(module)
                                        
                                        showLessons = true
                                        showTest = false
                                        resumeLessons = false
                                        resumeTest = false
                                    }
                                    
                                } label: {
                                    
                                    //Learn Card
                                    HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.totLessons) Lessons ", time: module.content.time)
                                }
                                .padding(.top, 12)
                                
                                Button {
                                    
                                    //Preparing for TestView
                                    model.getQuestions(module) {
                                        model.beginTest(module.id)
                                        
                                        navigationPath.append(module)
                                        
                                        showLessons = false
                                        showTest = true
                                        resumeLessons = false
                                        resumeTest = false
                                        
                                        //Reset number of correct answers
                                        model.numCorrect = 0
                                    }
                                    
                                } label: {
                                    
                                    //Test Card
                                    HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.totQuestions) Lessons ", time: module.test.time)
                                }
                                
                            }
                            
                        }
                    }
                    .buttonStyle(.plain)
                    .padding()
                }
                
            }
            .navigationDestination(for: Module.self) { module in
                
                if showLessons {
                    
                    ContentView(navigationPath: $navigationPath)
                    
                } else if resumeLessons {
                    
                    ContentDetailView(lessonIndex: user.lastLesson ?? 0, navigationPath: $navigationPath)
                    
                } else if showTest || resumeTest {
                    
                    TestView(navigationPath: $navigationPath)
                }
                    
            }
            .navigationTitle(navTitle)
        }

        
    }
}

