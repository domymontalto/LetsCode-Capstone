//
//  Module.swift
//  LetsCode
//
//  Created by Domenico Montalto on 10/4/23.
//

import Foundation

struct Module: Decodable, Identifiable {
    
    var id: String = ""
    var category: String = ""
    var content: Content = Content()
    var test: Test = Test()
}
