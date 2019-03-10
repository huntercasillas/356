//
//  Model.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/22/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class Model {
    
    var authToken: String = "auth"
    var mainPersonID: String = "personID"
    var allPersons: [Person] = [Person]()
    var allEvents: [Event] = [Event]()
    
    init() {
        
    }
    
    func getMainPersonID() -> String {
        return mainPersonID
    }
    
    func setMainPersonID(personID: String) {
        self.mainPersonID = personID
    }
    
    func getAuthToken() -> String {
        return authToken
    }
    
    func setAuthToken(authToken: String) {
        self.authToken = authToken
    }
}
