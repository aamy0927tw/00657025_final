//
//  SelectTrain.swift
//  00657025_final
//
//  Created by User21 on 2020/6/11.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct SelectTrain: View {
    @State private var startingStation: String = ""
    @State private var endingStation: String = ""
    @State private var startTimeHour: String = "00"
    @State private var startTimeMin: String = "00"
    @State private var endTimeHour: String = "23"
    @State private var endTimeMin: String = "59"
    var hours = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23"]
    var mins = ["00", "30"]
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            startingStation = "基隆"
            endingStation = "臺北"
        }
        else {
            startingStation = "Keelung"
            endingStation = "Taipei"
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Text(NSLocalizedString("Input starting station", comment: "") + ": ")
                    TextField(NSLocalizedString("Input starting station", comment: ""), text: $startingStation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                HStack {
                    Text(NSLocalizedString("Input ending station", comment: "") + ": ")
                    TextField(NSLocalizedString("Input ending station", comment: ""), text: $endingStation)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                Picker(selection: $startTimeHour, label: Text(NSLocalizedString("Choose starting hour", comment: ""))) {
                    ForEach(hours, id: \.self) { (hour) in
                        Text(hour)
                    }
                }
                Picker(selection: $startTimeMin, label: Text(NSLocalizedString("Choose starting minute", comment: ""))) {
                    ForEach(mins, id: \.self) { (min) in
                        Text(min)
                    }
                }
                Text(NSLocalizedString("Starting time you choose", comment: "") + ": \(startTimeHour):\(startTimeMin)")
                    .padding()
                    .border(Color.orange, width: 3)
                Picker(selection: $endTimeHour, label: Text(NSLocalizedString("Choose ending hour", comment: ""))) {
                    ForEach(hours, id: \.self) { (hour) in
                        Text(hour)
                    }
                }
                Picker(selection: $endTimeMin, label: Text(NSLocalizedString("Choose ending minute", comment: ""))) {
                    ForEach(mins, id: \.self) { (min) in
                        Text(min)
                    }
                }
                Text(NSLocalizedString("Ending time you choose", comment: "") + ": \(endTimeHour):\(endTimeMin)")
                .padding()
                .border(Color.orange, width: 3)
                NavigationLink(destination: TrainList(startingStation: $startingStation, endingStation: $endingStation, startTimeHour: $startTimeHour, startTimeMin: $startTimeMin, endTimeHour: $endTimeHour, endTimeMin: $endTimeMin)) {
                    Text(NSLocalizedString("OK", comment: ""))
                    .font(Font.system(size: 30))
                    .font(.largeTitle)
                }
            }
            .frame(height: 350)
            .navigationBarTitle(NSLocalizedString("Search Train Today", comment: ""))
        }
    }
}

struct SelectTrain_Previews: PreviewProvider {
    static var previews: some View {
        SelectTrain()
    }
}
