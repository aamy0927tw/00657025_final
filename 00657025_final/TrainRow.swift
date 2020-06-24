//
//  TrainRow.swift
//  00657025_final
//
//  Created by User17 on 2020/6/9.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct TrainRow: View {
    @Binding var startingStation: String
    @Binding var endingStation: String
    var train: TrainTimetable
    @State private var name: String = ""
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            self.name = train.TrainInfo.TrainTypeName.Zh_tw!
        }
        else {
            self.name = train.TrainInfo.TrainTypeName.En!
        }
    }
    
    func searchTime(station: String) -> String {
        for stop in train.StopTimes {
            if stop.StationName.Zh_tw! == station || stop.StationName.En! == station {
                return stop.ArrivalTime!
            }
        }
        return "---"
    }
    
    var body: some View {
        GeometryReader { (geometry) in
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("TrainNo", comment: "") + ": ").font(Font.system(size: 20)) + Text(self.train.TrainInfo.TrainNo).bold().font(Font.system(size: 20)) + Text(" (" + self.name + ")").bold().font(Font.system(size: 20))
                    Text(NSLocalizedString("Departure Time", comment: "") + ": ").font(Font.system(size: 20)) + Text(self.searchTime(station: self.startingStation)).bold().font(Font.system(size: 20))
                }
                .padding()
                .onAppear {
                    self.getCurrentLanguage()
                }
                Spacer()
            }
            .frame(width: geometry.size.width * 400 / 414, height: geometry.size.height * 400 / 414)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.green]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            .cornerRadius(12)
            .shadow(radius: 5)
        }
    }
}
