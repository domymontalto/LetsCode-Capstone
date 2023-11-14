//
//  AwardView.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/10/23.
//

import SwiftUI

struct AwardView: View {
    
    @Binding var selectedAward: String
    @Binding var sheetVisible: Bool
    
    var body: some View {
        
        ZStack{
            
            Image(selectedAward)
                .resizable()
                .aspectRatio(contentMode: .fit)
            
            VStack {
                
                
                HStack {
                    
                    Spacer()
                    
                    Button {
                        sheetVisible = false
                        
                    } label: {
                        Image(systemName: "x.circle")
                            .scaleEffect(2)
                            .foregroundColor(.black)
                    }
                    .padding()
                    
                }
                
                Spacer()
                
            }
            
        }
        
    }
        
        
}

#Preview {
    AwardView(selectedAward: Binding.constant("JavaBlack"), sheetVisible: Binding.constant(true))
}
