//
//  Event.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class Event: Codable {
    
    var eventID: String
    var descendant: String
    var personID: String
    var latitude: String
    var longitude: String
    var country: String
    var city: String
    var eventType: String
    var year: String
    
    init (eventID: String, descendant: String, personID: String, latitude: String,
          longitude: String, country: String, city: String, eventType: String, year: String) {
        
        self.eventID = eventID
        self.descendant = descendant
        self.personID = personID
        self.latitude = latitude
        self.longitude = longitude
        self.country = country
        self.city = city
        self.eventType = eventType
        self.year = year
    }
}
