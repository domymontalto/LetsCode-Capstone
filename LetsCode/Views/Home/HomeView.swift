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

        ScrollView {
            
            LazyVStack {
                
                ForEach(model.modules) { module in
                    
                    //Learning Card
                    
                    ZStack {
                        
                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .aspectRatio(CGSize(width: 335, height: 175), contentMode: .fit)
                        
                        HStack {
                            
                            //Image
                            Image(module.category)
                                .resizable()
                                .frame(width: 116, height: 116)
                                .clipShape(Circle())
                            
                            Spacer()
                            
                            //Text
                            VStack(alignment: .leading, spacing: 10) {
                                
                                //HeadLine
                                Text("Learn \(module.category)")
                                    .fontWeight(.bold)
                                
                                //Description
                                Text(module.content.description)
                                    .font(.caption)
                                    .padding(.bottom, 20)
                                
                                
                                //Icons
                                HStack {
                                    
                                    //Number of lessons/questions
                                    Image(systemName: "text.book.closed")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    
                                    Text("\(module.content.totLessons) Lessons")
                                        .font(Font.system(size: 10))
                                    
                                    Spacer()
                                    
                                    //Time
                                    
                                    Image(systemName: "clock")
                                        .resizable()
                                        .frame(width: 15, height: 15)
                                    
                                    
                                    
                                    Text("\(module.content.time)")
                                        .font(Font.system(size: 10))
                                    
                                }
                                
                            }
                            .padding(.leading)
                            
                            
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    
                    //Test Card
                    
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ContentModel())
}
