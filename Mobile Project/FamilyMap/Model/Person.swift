//
//  Person.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class Person: Codable {
    
    var personID: String
    var descendant: String
    var firstName: String
    var lastName: String
    var gender: String
    var father: String?
    var mother: String?
    var spouse: String?
    
    init (personID: String, descendant: String, firstName: String, lastName: String,
          gender: String, father: String, mother: String, spouse: String) {
        
        self.personID = personID
        self.descendant = descendant
        self.firstName = firstName
        self.lastName = lastName
        self.gender = gender
        self.father = father
        self.mother = mother
        self.spouse = spouse
    }
}
