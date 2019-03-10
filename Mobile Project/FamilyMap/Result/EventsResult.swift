//
//  EventsResult.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/21/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation

public class EventsResult: Decodable {
    
    var data: Array<Event> = Array()
    
    init(events: Array<Event>) {
        self.data = events;
    }
}
