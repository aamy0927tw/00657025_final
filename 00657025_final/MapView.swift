//
//  MapView.swift
//  00657025_final
//
//  Created by User23 on 2020/6/8.
//  Copyright © 2020 User23. All rights reserved.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D
    var annotations = [MKPointAnnotation]()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapView>) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(annotations, animated: true)
    }
}
