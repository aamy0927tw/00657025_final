//
//  StationRow.swift
//  00657025_final
//
//  Created by User23 on 2020/6/6.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct StationRow: View {
    var station: Station
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
        GeometryReader { (geometry) in
            VStack(alignment: .leading) {
                Text(self.name + NSLocalizedString("Train Station", comment: "")).font(Font.system(size: 25))
            }.onAppear {
                self.getCurrentLanguage()
            }
            .frame(width: geometry.size.width * 300 / 414, height: geometry.size.height * 400 / 414)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            .cornerRadius(15)
            .shadow(radius: 7)
        }
    }
}

struct StationRow_Previews: PreviewProvider {
    static var previews: some View {
        StationRow(station: Station(StationID: "111", StationName: NameType(Zh_tw: "臺北", En: "Taipei"), StationPosition: PointType(PositionLat: 22.65214, PositionLon: 120.50294), StationAddress: "9999", StationPhone: "02123"))
    }
}

