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

            Text("Hello, world!!!")
            .padding()
    }
}

#Preview {
    HomeView()
}
