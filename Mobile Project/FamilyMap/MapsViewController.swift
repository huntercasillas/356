//
//  MapsViewController.swift
//  FamilyMap
//
//  Created by Hunter Casillas on 11/22/18.
//  Copyright © 2018 Hunter Casillas. All rights reserved.
//
import Foundation
import UIKit
import MapKit

class MapsViewController: UIViewController {
    
    // Global struct
    struct Global {
        static var personID = ""
        static var eventID = ""
        static var mapType: MKMapType = .standard
        static var eventClicked = false
        static var reloadData = false
        static var typeChange = false
        static var filterChange = false
        static var lineChange = false
        static var zoomChange = false
        static var showLifeStoryLines = true
        static var finalLineColor: UIColor = .black
        static var lifeStoryColor: UIColor = .red
        static var showFatherLines = true
        static var fatherLineageColor: UIColor = .green
        static var showMotherLines = true
        static var motherLineageColor: UIColor = .magenta
        static var showSpouseLines = true
        static var spouseColor: UIColor = .blue
        static var currentAnnotation: MapMarker?
        static var span = MKCoordinateSpan(latitudeDelta: 120.0, longitudeDelta: 120.0)
        static var location = CLLocationCoordinate2DMake(16.6458, -38.9250)
        static var region = MKCoordinateRegion(center: location, span: span)
    }
    
    // Hide status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Declare initial variables
    var allPersons = [String: Person]()
    var allEvents = [String: Event]()
    var allAnnotations = Array<MKAnnotation>()
    var lifeStoryAnnotations = Array<MKAnnotation>()
    var fatherTreeAnnotations = Array<MKAnnotation>()
    var motherTreeAnnotations = Array<MKAnnotation>()
    var spouseAnnotations = Array<MKAnnotation>()
    
    // Initial set up
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        mapView.delegate = self
        let latitude:CLLocationDegrees = 16.6458
        let longitude:CLLocationDegrees = -38.9250
        let latDelta:CLLocationDegrees = 120.0
        let lonDelta:CLLocationDegrees = 120.0
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: false)
        
        allPersons = ViewController.Global.finalPersons
        allEvents = ViewController.Global.finalEvents
        allAnnotations.removeAll()
        lifeStoryAnnotations.removeAll()
        fatherTreeAnnotations.removeAll()
        motherTreeAnnotations.removeAll()
        spouseAnnotations.removeAll()
        
        addAnnotations()
    }
    
    // Add relationship lines to map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = Global.finalLineColor
            renderer.lineWidth = 1.5
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    // Add events to map
    func addAnnotations() {
        
        for (eventID, event) in allEvents {
            let eventType = event.eventType
            let personID = event.personID
            let person = allPersons[personID]
            let title = person!.firstName + " " + person!.lastName
            let sub1 = eventType + ": "
            let sub2 = event.city + ", " + event.country
            let sub3 = " (" + String(event.year) + ")"
            let subtitle = sub1 + sub2 + sub3
            let eventLat: Double = Double(event.latitude)!
            let eventLong: Double = Double(event.longitude)!
            let coordinate = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
            
            let marker = MapMarker(title: title, locationName: subtitle, discipline: eventType, coordinate: coordinate, eventID: eventID, personID: personID)
            
            mapView.register(MapMarkerView.self,
                             forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
            
            allAnnotations.append(marker)
        }
        mapView.addAnnotations(allAnnotations)
    }
    
    // Reload map if it re-appears
    override func viewWillAppear(_ animated: Bool) {
        
        if Global.eventClicked {
            Global.eventClicked = false
            mapView.setRegion(Global.region, animated: true)
            
            for annotation in allAnnotations {
                let foundAnnotation = annotation as! MapMarker
                if foundAnnotation.eventID == Global.eventID {
                    mapView.selectAnnotation(annotation, animated: true)
                }
            }
        }
        
        if Global.typeChange {
            Global.typeChange = false
            mapView.mapType = Global.mapType
        }
        
        if Global.filterChange {
            Global.filterChange = false
            allPersons = ViewController.Global.finalPersons
            allEvents = ViewController.Global.updatedEvents
            mapView.removeAnnotations(allAnnotations)
            allAnnotations.removeAll()
            lifeStoryAnnotations.removeAll()
            fatherTreeAnnotations.removeAll()
            motherTreeAnnotations.removeAll()
            spouseAnnotations.removeAll()
            addAnnotations()
        }
        
        if Global.lineChange {
            Global.lineChange = false
            allPersons = ViewController.Global.finalPersons
            allEvents = ViewController.Global.updatedEvents
            mapView.removeAnnotations(allAnnotations)
            allAnnotations.removeAll()
            lifeStoryAnnotations.removeAll()
            fatherTreeAnnotations.removeAll()
            motherTreeAnnotations.removeAll()
            spouseAnnotations.removeAll()
            addAnnotations()
        }
        
        if Global.reloadData {
            Global.reloadData = false
            allPersons = ViewController.Global.finalPersons
            allEvents = ViewController.Global.finalEvents
            mapView.removeAnnotations(allAnnotations)
            allAnnotations.removeAll()
            lifeStoryAnnotations.removeAll()
            fatherTreeAnnotations.removeAll()
            motherTreeAnnotations.removeAll()
            spouseAnnotations.removeAll()
            
            let latitude:CLLocationDegrees = 16.6458
            let longitude:CLLocationDegrees = -38.9250
            let latDelta:CLLocationDegrees = 120.0
            let lonDelta:CLLocationDegrees = 120.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = CLLocationCoordinate2DMake(latitude, longitude)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: false)
            addAnnotations()
        }
    }
    
    // Zoom out button function
    @IBAction func ZoomOut(_ sender: Any) {
        
        if Global.currentAnnotation != nil {
            let currentAnnotation = Global.currentAnnotation
            let latDelta:CLLocationDegrees = 120.0
            let lonDelta:CLLocationDegrees = 120.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = currentAnnotation!.coordinate
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        } else {
            let currentRegion = mapView.region
            let location = currentRegion.center
            let latDelta:CLLocationDegrees = 120.0
            let lonDelta:CLLocationDegrees = 120.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Zoom in button function
    @IBAction func ZoomIn(_ sender: Any) {
        
        if Global.currentAnnotation != nil {
            let currentAnnotation = Global.currentAnnotation
            let latDelta:CLLocationDegrees = 20.0
            let lonDelta:CLLocationDegrees = 20.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let location = currentAnnotation!.coordinate
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
            
        } else {
            let currentRegion = mapView.region
            let location = currentRegion.center
            let latDelta:CLLocationDegrees = 20.0
            let lonDelta:CLLocationDegrees = 20.0
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
            let region = MKCoordinateRegion(center: location, span: span)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    // Center button function
    @IBAction func Center(_ sender: Any) {
        let latitude:CLLocationDegrees = 16.6458
        let longitude:CLLocationDegrees = -38.9250
        let latDelta:CLLocationDegrees = 120.0
        let lonDelta:CLLocationDegrees = 120.0
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
    
    // Create custom annotations with icons
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseIdentifier = "annotationView"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if #available(iOS 11.0, *) {
            if view == nil {
                view = MapMarkerView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
            view?.displayPriority = .required
        } else {
            if view == nil {
                view = MapMarkerView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            }
        }
        view?.annotation = annotation
        view?.canShowCallout = true
        return view
    }
    
    func findRelatinoshipLines() {
        lifeStoryAnnotations.removeAll()
        fatherTreeAnnotations.removeAll()
        motherTreeAnnotations.removeAll()
        spouseAnnotations.removeAll()
        
        let currentPersonID = Global.currentAnnotation?.personID
        let currentPerson = allPersons[currentPersonID!]
        let currentEventID = Global.currentAnnotation?.eventID
        let currentEvent = allEvents[currentEventID!]
        
        var lifeStoryEvents = [Event]()
        var spouseEvents = [Event]()
        
        let currentSpouseID = currentPerson!.spouse ?? ""
        let currentFatherID = currentPerson!.father ?? ""
        let currentMotherID = currentPerson!.mother ?? ""
        
        let marker = createMarker(event: currentEvent!)
        fatherTreeAnnotations.append(marker)
        motherTreeAnnotations.append(marker)
        spouseAnnotations.append(marker)
        
        if Global.showLifeStoryLines {
            for (_, event) in allEvents {
                if event.personID == currentPersonID {
                    lifeStoryEvents.append(event)
                }
            }
            
            lifeStoryEvents = lifeStoryEvents.sorted(by: {$0.year < $1.year})
            for event in lifeStoryEvents {
                let marker = createMarker(event: event)
                lifeStoryAnnotations.append(marker)
            }
        }
        
        if Global.showFatherLines {
            findFather(fatherID: currentFatherID)
        }
        
        if Global.showMotherLines {
            findMother(motherID: currentMotherID)
        }
        
        if Global.showSpouseLines {
            for (_, event) in allEvents {
                if event.personID == currentSpouseID {
                    spouseEvents.append(event)
                }
            }
            
            spouseEvents = spouseEvents.sorted(by: {$0.year < $1.year})
            if spouseEvents.count > 0 {
                let marker = createMarker(event: spouseEvents[0])
                spouseAnnotations.append(marker)
            }
        }
    }
    
    func findFather(fatherID: String) {
        var nextParent: Person?
        var fatherLineageEvents = [Event]()
        
        // Father Side
        for (_, event) in allEvents {
            if event.personID == fatherID {
                nextParent = findFatherID(personID: event.personID)
                fatherLineageEvents.append(event)
            }
        }
        fatherLineageEvents = fatherLineageEvents.sorted(by: {$0.year < $1.year})
        if fatherLineageEvents.count > 0 {
            let marker = createMarker(event: fatherLineageEvents[0])
            fatherTreeAnnotations.append(marker)
        }

        if nextParent != nil {
            findFather(fatherID: (nextParent?.personID)!)
        }
    }
    
    func findMother(motherID: String) {
        var nextParent: Person?
        var motherLineageEvents = [Event]()

        // Mother Side
        for (_, event) in allEvents {
            if event.personID == motherID {
                nextParent = findMotherID(personID: event.personID)
                motherLineageEvents.append(event)
            }
        }
        motherLineageEvents = motherLineageEvents.sorted(by: {$0.year < $1.year})
        if motherLineageEvents.count > 0 {
            let marker = createMarker(event: motherLineageEvents[0])
            motherTreeAnnotations.append(marker)
        }

        if nextParent != nil {
            findMother(motherID: (nextParent?.personID)!)
        }
    }
    
    func findFatherID(personID: String) -> Person? {
        var foundParentID = ""
        let foundPerson = allPersons[personID]
        if foundPerson!.father != nil {
            foundParentID = foundPerson!.father!
        }
        let foundFather = allPersons[foundParentID]
        if foundFather != nil {
            return foundFather
        }
        return nil
    }
    
    func findMotherID(personID: String) -> Person? {
        var foundParentID = ""
        let foundPerson = allPersons[personID]
        if foundPerson!.mother != nil {
            foundParentID = foundPerson!.mother!
        }
        let foundMother = allPersons[foundParentID]
        if foundMother != nil {
            return foundMother
        }
        return nil
    }
    
    // Create and return marker to add to list of annotations
    func createMarker(event: Event) -> MapMarker {
        let eventType = event.eventType
        let personID = event.personID
        let person = allPersons[personID]
        let eventName = person!.firstName + " " + person!.lastName
        let eventID = event.eventID
        let title = eventName
        let sub1 = eventType + ": "
        let sub2 = event.city + ", " + event.country
        let sub3 = " (" + String(event.year) + ")"
        let subtitle = sub1 + sub2 + sub3
        let eventLat: Double = Double(event.latitude)!
        let eventLong: Double = Double(event.longitude)!
        let coordinate = CLLocationCoordinate2D(latitude: eventLat, longitude: eventLong)
        
        let marker = MapMarker(title: title, locationName: subtitle, discipline: eventType, coordinate: coordinate, eventID: eventID, personID: personID)
        
        mapView.register(MapMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        return marker
    }
    
    // Deselect annotation function
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        Global.currentAnnotation = nil
        mapView.removeOverlays(mapView.overlays)
    }
    
    // Select annotation function
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        let currentAnnotation = view.annotation as? MapMarker
        Global.currentAnnotation = currentAnnotation
        findRelatinoshipLines()
        
        if Global.showLifeStoryLines {
            var locations = lifeStoryAnnotations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: &locations, count: locations.count)
            Global.finalLineColor = Global.lifeStoryColor
            mapView.addOverlay(polyline)
        }
        
        if Global.showFatherLines {
            var fatherLocations = fatherTreeAnnotations.map { $0.coordinate }
            let fatherPolyline = MKPolyline(coordinates: &fatherLocations, count: fatherLocations.count)
            Global.finalLineColor = Global.fatherLineageColor
            
            mapView.addOverlay(fatherPolyline)
        }
        
        if Global.showMotherLines {
            var motherLocations = motherTreeAnnotations.map { $0.coordinate }
            let motherPolyline = MKPolyline(coordinates: &motherLocations, count: motherLocations.count)
            Global.finalLineColor = Global.motherLineageColor
            
            mapView.addOverlay(motherPolyline)
        }
        
        if Global.showSpouseLines {
            var locations = spouseAnnotations.map { $0.coordinate }
            let polyline = MKPolyline(coordinates: &locations, count: locations.count)
            Global.finalLineColor = Global.spouseColor
            mapView.addOverlay(polyline)
        }
        
        if Global.zoomChange == true {
            Global.zoomChange = false
        } else {
            let currentRegion = mapView.region
            let span = currentRegion.span
            let location = currentAnnotation!.coordinate
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPerson" {
            if let destination = segue.destination as? PersonViewController {
                destination.personID = Global.personID
            }
        }
    }
}

extension MapsViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        let currentAnnotation = view.annotation as? MapMarker
        let personID = currentAnnotation?.personID
        let eventID = currentAnnotation?.eventID
        Global.personID = personID!
        Global.eventID = eventID!
        
        performSegue(withIdentifier: "ShowPerson", sender: self)
    }
}
