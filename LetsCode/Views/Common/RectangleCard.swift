//
//  RectangleCard.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/12/23.
//

import SwiftUI

struct RectangleCard: View {
    
    var color = Color.white
    
    var body: some View {
        
        Rectangle()
            .foregroundColor(color)
            .cornerRadius(10)
            .shadow(radius: 5)
        
    }
}

#Preview {
    RectangleCard()
}
