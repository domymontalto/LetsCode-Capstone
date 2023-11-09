//
//  Content.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

struct Content: Decodable, Identifiable, Hashable {
    
    var id: String = ""
    var image: String = ""
    var time: String = ""
    var description: String = ""
    var totLessons : Int = 0
    var lessons: [Lesson] = [Lesson]()
    
}
