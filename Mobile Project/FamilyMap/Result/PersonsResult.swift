//
//  PersonsResult.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class PersonsResult: Decodable {
    
    var data: Array<Person> = Array()
    
    init(persons: Array<Person>) {
        self.data = persons;
    }
}
