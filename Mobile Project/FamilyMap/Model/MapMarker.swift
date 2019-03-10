//
//  MapMarker.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/23/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation
import MapKit

class MapMarker: NSObject, MKAnnotation {
    let title: String?
    let locationName: String
    let discipline: String
    let coordinate: CLLocationCoordinate2D
    let eventID: String
    let personID: String
    
    init(title: String, locationName: String, discipline: String, coordinate: CLLocationCoordinate2D, eventID: String, personID: String) {
        self.title = title
        self.locationName = locationName
        self.discipline = discipline
        self.coordinate = coordinate
        self.eventID = eventID
        self.personID = personID
        
        super.init()
    }
    
    var subtitle: String? {
        return locationName
    }
    
    var color: UIColor  {
        switch discipline {
        case "Birth":
            return .orange
        case "Baptism":
            return .green
        case "Graduation":
            return .purple
        case "Marriage":
            return .blue
        case "Death":
            return .red
        default:
            return .black
        }
    }
    
    var imageName: String? {
        switch discipline {
        case "Birth":
            return "Birth"
        case "Baptism":
            return "Baptism"
        case "Graduation":
            return "Graduation"
        case "Marriage":
            return "Marriage"
        case "Death":
            return "Death"
        default:
            return "Default"
        }
    }
}
