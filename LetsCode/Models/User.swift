//
//  User.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/31/23.
//

import Foundation

class User {
    
    var name: String = ""
    var email: String = ""
    var lastModule: Int?
    var lastLesson: Int?
    var lastQuestion: Int?
    var correctAnswers:Int?
    var awards: [Award] = [Award]()
}
