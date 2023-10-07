//
//  ContentView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/2/23.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var model:ContentModel
    
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("What do you want to do today?")
                    .padding(.leading, 20)
                
                ScrollView {
                    LazyVStack {
                        
                        ForEach(model.modules) { module in
                            
                            VStack(spacing: 20) {
                                
                                //Learning Card
                                HomeViewRow(image: module.content.image, title: "Learn \(module.category)", description: module.content.description, count: "\(module.content.totLessons) Lessons ", time: module.content.time)
                                
                                //Test Card
                                HomeViewRow(image: module.test.image, title: "\(module.category) Test", description: module.test.description, count: "\(module.test.totQuestions) Lessons ", time: module.test.time)
                            }
                            
                        }
                    }
                    .padding()
                }
                
                
            }
            .navigationTitle("Get Started")
        }

        
    }
}

#Preview {
    HomeView()
        .environmentObject(ContentModel())
}
