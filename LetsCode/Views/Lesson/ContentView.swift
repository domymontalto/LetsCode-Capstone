//
//  ContentView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model:ContentModel
    
    
    var body: some View {

        ScrollView {

            LazyVStack {
                
                if model.currentModule != nil {
                    
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        
                        NavigationLink {
                            
                            ContentDetailView()
                                .onAppear(perform: {
                                    model.beginLesson(index)
                                })
                            
                        } label: {
                            ContentViewRow(index: index)

                        }
                        

                        
                    }
                    
                }
                
            }
            .buttonStyle(.plain)
            
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
            
        }
        
    }
}

#Preview {
    ContentView()
}
