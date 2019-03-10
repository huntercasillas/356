//
//  MapMarkerView.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/23/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//

import Foundation
import MapKit

class MapMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let annotation = newValue as? MapMarker else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: 0, y: 15)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            markerTintColor = annotation.color
            if let imageName = annotation.imageName {
                glyphImage = UIImage(named: imageName)
            } else {
                glyphImage = UIImage(named: "Default")
            }
        }
    }
}
