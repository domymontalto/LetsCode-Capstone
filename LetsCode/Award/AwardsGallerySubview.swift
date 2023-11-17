//
//  AwardsGallerySubview.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/10/23.
//

import SwiftUI

struct AwardsGallerySubview: View {
    
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @Binding var awardsToDisplay: [String]
    @Binding var clickable: Bool
    
    @State var sheetVisible = false
    @State var selectedAward = ""
    
    var body: some View {
        
        let isLandscape = horizontalSizeClass == .regular && verticalSizeClass == .compact
        
        GeometryReader { proxy in
            
            ScrollView {
                
                if isLandscape == false {
                    
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
                                        
                                        if clickable {
                                            
                                            sheetVisible = true
                                        }
                                    }
                                
                            }
                            .shadow(radius: 5)
                            
                        }
                        
                    }
                    
                } else {
                    
                    LazyVGrid(columns: [GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10), GridItem(spacing: 10)], spacing: 10) {
                        
                        //forEach award make a cliccable image in a rectangle
                        ForEach($awardsToDisplay, id: \.self) { $award in
                            
                            ZStack {
                                RectangleCard(color: .white)
                                    .padding()
                                    .frame(maxWidth: 90)
                                
                                Image(award)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(maxWidth: (proxy.size.width - 110) / 12)
                                    .clipped()
                                    .padding()
                                    .onTapGesture {
                                        selectedAward = award
                                        
                                        if clickable {
                                            
                                            sheetVisible = true
                                        }
                                    }
                                
                            }
                            .shadow(radius: 5)
                            
                        }
                        
                    }
                    
                    
                }
            }
            .scrollIndicators(.hidden)
            
        }
        .sheet(isPresented: $sheetVisible) {
            AwardView(selectedAward: $selectedAward, sheetVisible: $sheetVisible)
        }
        
    }
    
}

//#Preview {
//    AwardsGallerySubview()
//}
