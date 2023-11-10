//
//  ResumeCard.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/9/23.
//

import SwiftUI

struct ResumeCard: View {
    
    var resumeTitle:String
    
    
    var body: some View {
        
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

//#Preview {
//    ResumeCard()
//}
