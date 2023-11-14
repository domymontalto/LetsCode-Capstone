//
//  AwardsGallerySubview.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/10/23.
//

import SwiftUI

struct AwardsGallerySubview: View {
    
    @Binding var awardsToDisplay: [String]
    
    @State var sheetVisible = false
    @State var selectedAward = ""
    
    var body: some View {

        GeometryReader { proxy in
            
            ScrollView(showsIndicators: false){
                
                LazyVGrid(columns: [GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10)], spacing: 10) {
                    
                    //forEach award make a cliccable image in a rectangle
                    ForEach($awardsToDisplay, id: \.self) { $award in
                        
                        ZStack {
                            RectangleCard(color: .white)
                                .padding()
                            
                            Image(award)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: (proxy.size.width - 20) / 3)
                                .clipped()
                                .padding()
                                .onTapGesture {
                                    selectedAward = award
                                    sheetVisible = true
                                }
                            
                        }
                        .shadow(radius: 10)
                        
                    }
                    
                }
            }
        }
        .sheet(isPresented: $sheetVisible) {
            AwardView(selectedAward: $selectedAward, sheetVisible: $sheetVisible)
        }
        
    }
}

//#Preview {
//    AwardsGallerySubview()
//}
