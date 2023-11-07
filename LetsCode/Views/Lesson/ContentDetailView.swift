//
//  ContentDetailView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/10/23.
//

import SwiftUI

// To import AVKit go to LetsCode then frameworks libraries and embedded content click on the plus button and add AVKit.framework
import AVKit

struct ContentDetailView: View {
    
    @EnvironmentObject var model: ContentModel
    
    @State var lessonIndex: Int
    
    var body: some View {
        
        let lesson = model.currentLesson
        let url = URL(string: Constants.videoHostUrl + (lesson?.video ?? ""))
        
        VStack {
            
            //Only show video if we get a valid URL
            if url != nil {
                
                PlayerViewController(model: model, videoURL: url!)
                    .cornerRadius(10)
            
            }
            
            //Description
            CodeTextView()
            
            //Show next lesson button, only if there is a next lesson
            if model.hasNextLesson() {
                
                Button {
                    
                    //Advance the lesson and lessonIndex
                    model.nextLesson()
                    lessonIndex += 1
                    
                } label: {
                    
                    ZStack{
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)

                        
                        Text("Next Lesson: \(model.currentModule!.content.lessons[model.currentLessonIndex + 1].title)")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                        
                    }
                    
                }
                
            }
            else {
                
                //Show the complete button instead
                Button {
                    
                    //Advance the lesson
                    model.nextLesson()
                    
                    //Take user back to the HomeView
                    model.currentContentSelected = nil
                    
                } label: {
                    
                    ZStack{
                        
                        RectangleCard(color: .green)
                            .frame(height: 48)
                        
                        Text("Complete")
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                        
                    }
                    
                }
            }

            
        }
        .onAppear(perform: {
            model.beginLesson(lessonIndex)
        })
        .navigationTitle(lesson?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .padding()
        
    }
}

