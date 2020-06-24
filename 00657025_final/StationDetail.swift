//
//  StationDetail.swift
//  00657025_final
//
//  Created by User23 on 2020/6/6.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI
import MapKit

struct MapScaled: View {
    var station: Station
    @Binding var annotations: [MKPointAnnotation]
    @Binding var mapHeight: CGFloat
    @Binding var smallMap: Bool
    @Binding var name: String
    
    var body: some View {
        HStack {
            if smallMap == false {
                Button(NSLocalizedString("Zoom in", comment: "")) {
                    self.mapHeight = 130
                    self.smallMap = true
                }
            } else {
                Button(NSLocalizedString("Zoom out", comment: "")) {
                    self.mapHeight = 380
                    self.smallMap = false
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = CLLocationCoordinate2D(latitude: self.station.StationPosition.PositionLat!, longitude: self.station.StationPosition.PositionLon!)
                    annotation.title = "\(String(describing: self.name))"
                    self.annotations.append(annotation)
                }
            }
        }
    }
}

struct StationDetail: View {
    var station: Station
    @State private var annotations = [MKPointAnnotation]()
    @State private var mapHeight: CGFloat = 130
    @State private var smallMap: Bool = true
    @State private var showSheet: Bool = false
    @State private var name: String = ""
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            name = station.StationName.Zh_tw!
        }
        else {
            name = station.StationName.En!
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                MapScaled(station: self.station, annotations: self.$annotations, mapHeight: self.$mapHeight.animation(), smallMap: self.$smallMap, name: self.$name)
                MapView(coordinate: CLLocationCoordinate2D(latitude: self.station.StationPosition.PositionLat!, longitude: self.station.StationPosition.PositionLon!), annotations: self.annotations)
                
                if self.smallMap {
                    Group {
                        HStack {
                            Text(NSLocalizedString("Address", comment: "") + ": ").font(Font.system(size: 20))
                            Spacer()
                            Text(self.station.StationAddress!)
                        }.padding()
                        HStack {
                            Text(NSLocalizedString("Phone", comment: "") + ": ").font(Font.system(size: 20))
                            Spacer()
                            Text(self.station.StationPhone!)
                        }.padding()
                        HStack {
                            Text(NSLocalizedString("AddressURL", comment: "") + ": \n").font(Font.system(size: 20)) + Text(NSLocalizedString("Long Press URL", comment: "")).font(Font.system(size: 15)).foregroundColor(.gray)
                            Spacer()
                            Text(self.station.StationURL!)
                            .onLongPressGesture(minimumDuration: 1) {
                                self.showSheet = true
                            }
                        }.padding()
                    }
                    .sheet(isPresented: self.$showSheet) {
                        WebView(station: self.station)
                    }
                }
            }
            .onAppear {
                self.getCurrentLanguage()
            }
        }.navigationBarTitle(self.name + NSLocalizedString("Train Station", comment: ""))
    }
}
