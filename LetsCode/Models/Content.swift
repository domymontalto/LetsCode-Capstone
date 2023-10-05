//
//  Content.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

struct Content: Decodable, Identifiable {
    
    var id: Int
    var image: String
    var time: String
    var description: String
    var totLessons : Int
    var lessons: [Lesson]
    
}
