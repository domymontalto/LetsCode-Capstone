//
//  ContentViewRow.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/7/23.
//

import SwiftUI

struct ContentViewRow: View {
    
    @EnvironmentObject var model: ContentModel
    
    var index:Int
    
    
    var body: some View {
        
        let lesson = model.currentModule!.content.lessons[index]
        
        //Lesson Card
        ZStack(alignment: .leading) {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .frame(height: 66)
                
                
            
            HStack(spacing: 30) {
                
                Text("\(index + 1)")
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    
                    Text(lesson.title)
                        .fontWeight(.bold)
                    
                    Text(lesson.duration)
                }
                
            }
            .padding()
            
        }
        .padding(.bottom, 5)
        
    }
}

//#Preview {
//    ContentViewRow()
//}
