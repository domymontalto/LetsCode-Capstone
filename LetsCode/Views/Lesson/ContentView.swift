//
//  ContentView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/7/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model:ContentModel
    
    @Binding var navigationPath: NavigationPath
    
    var body: some View {

        ScrollView {

            LazyVStack {
                
                if model.currentModule != nil {
                    
                    ForEach(0..<model.currentModule!.content.totLessons) { index in
                        
                        NavigationLink {

                            ContentDetailView(lessonIndex: index, navigationPath: $navigationPath)
                            
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
        .scrollIndicators(.hidden)
        
    }
}

//#Preview {
//    ContentView()
//}
