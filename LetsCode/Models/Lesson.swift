//
//  Lesson.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

struct Lesson: Decodable, Identifiable, Hashable {
    
    var id: String = ""
    var title: String = ""
    var video: String = ""
    var duration: String = ""
    var explanation: String = ""
    var difficulty: String = ""
}
