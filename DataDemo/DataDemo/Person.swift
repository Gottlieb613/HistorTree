//
//  Person.swift
//  DataDemo
//
//  Created by Charlie Gottlieb on 6/5/24.
//

import Foundation
import SwiftData

@Model
class Person: Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var gender: String //t=male, f=female
    
    init(firstName: String, lastName: String, gender: String) {
        self.id = UUID().uuidString
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
    }
    
}
