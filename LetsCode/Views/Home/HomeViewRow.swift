//
//  HomeViewRow.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/6/23.
//

import SwiftUI

struct HomeViewRow: View {
    
    var image: String
    var title: String
    var description: String
    var count: String
    var time: String
    
    
    var body: some View {
        
        ZStack {
            
            Rectangle()
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
            
            HStack {
                
                //Image
                Image(image)
                    .resizable()
                    .frame(width: 116, height: 116)
                    .clipShape(Circle())
                
                Spacer()
                
                //Text
                VStack(alignment: .leading, spacing: 10) {
                    
                    //HeadLine
                    Text(title)
                        .fontWeight(.bold)
                    
                    //Description
                    Text(description)
                        .font(.caption)
                        .padding(.bottom, 20)
                    
                    
                    //Icons
                    HStack {
                        
                        //Number of lessons/questions
                        Image(systemName: "text.book.closed")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        Text(count)
                            .font(Font.system(size: 10))
                        
                        Spacer()
                        
                        //Time
                        
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 15, height: 15)
                        
                        
                        
                        Text(time)
                            .font(Font.system(size: 10))
                        
                    }
                    
                }
                .padding(.leading)
                
                
            }
            .padding(.horizontal, 20)
        }

        
    }
}

#Preview {
    HomeViewRow(image: "Java", title: "Learn Java", description: "description", count: "2 Lessons", time: "3 Hours")
}
