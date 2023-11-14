//
//  Award.swift
//  LetsCode
//
//  Created by Domenico Montalto on 11/10/23.
//

import Foundation

struct Award: Identifiable, Hashable {
    
    var id: UUID = UUID()
    var name: String = ""
    var difficulty: String = ""
    var earnedImage: String = ""
    var unearnedImage: String = ""
}
