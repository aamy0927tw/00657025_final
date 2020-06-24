//
//  TrainDetail.swift
//  00657025_final
//
//  Created by User17 on 2020/6/9.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct TrainDetail: View {
    @Binding var startingStation: String
    @Binding var endingStation: String
    var train: TrainTimetable
    var tripLine = [NSLocalizedString("Neither", comment: ""), NSLocalizedString("Mountain", comment: ""), NSLocalizedString("Ocean", comment: "")]
    var YN = [NSLocalizedString("No", comment: ""), NSLocalizedString("Yes", comment: "")]
    @State private var startTime: String = ""
    @State private var destinationTime: String = ""
    @State private var showSheet: Bool = false
    
    func time() {
        for stop in self.train.StopTimes {
            if stop.StationName.Zh_tw! == startingStation || stop.StationName.En! == startingStation {
                startTime = stop.ArrivalTime!
            }
            if stop.StationName.Zh_tw! == endingStation || stop.StationName.En! == endingStation {
                destinationTime = stop.ArrivalTime!
            }
        }
    }
    
    var body: some View {
            Group {
                VStack(alignment: .leading) {
                    ExtractedView1(train: train)
                }
                Spacer()
                ExtractedView(train: train, YN: YN, tripLine: tripLine, startingStation: startingStation, endingStation: endingStation, startTime: startTime, destinationTime: destinationTime)
                Spacer()
                VStack(alignment: .center) {
                    Button(NSLocalizedString("Get tickets!", comment: "")) {
                        self.showSheet = true
                    }
                    .sheet(isPresented: $showSheet) {
                        SafariServices(url: URL(string: "https://www.railway.gov.tw/tra-tip-web/tip/tip001/tip121/query")!)
                    }
                }
                Spacer()
            }
            .onAppear {
                self.time()
            }.navigationBarTitle(NSLocalizedString("Details", comment: ""))
    }
}

struct ExtractedView: View {
    var train: TrainTimetable
    var YN: [String]
    var tripLine: [String]
    var startingStation: String
    var endingStation: String
    var startTime: String
    var destinationTime: String
    
    var body: some View {
        Group {
            ExtractedView2(train: train, startingStation: startingStation, endingStation: endingStation, startTime: startTime, destinationTime: destinationTime, tripLine: tripLine)
            ExtractedView4(train: train, YN: YN)
        }.padding()
    }
}

struct ExtractedView1: View {
    var train: TrainTimetable
    @State var sSta: String = ""
    @State var eSta: String = ""
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            sSta = train.TrainInfo.StartingStationName.Zh_tw!
            eSta = train.TrainInfo.EndingStationName.Zh_tw!
        }
        else {
            sSta = train.TrainInfo.StartingStationName.En!
            eSta = train.TrainInfo.EndingStationName.En!
        }
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text(self.train.TrainInfo.TrainNo).font(Font.system(size: 50)).fontWeight(.heavy) + Text(" ." + NSLocalizedString("Train", comment: "")).font(Font.system(size: 28))
                Text(NSLocalizedString("From", comment: "") + " ").font(Font.system(size: 22)) + Text(self.sSta).font(Font.system(size: 28)).foregroundColor(.red).underline() + Text(" " + NSLocalizedString("to", comment: "") + " ").font(Font.system(size: 22)) + Text(self.eSta).font(Font.system(size: 28)).foregroundColor(.red).underline()
        }.padding()
            .onAppear {
                self.getCurrentLanguage()
        }
    }
}

struct ExtractedView2: View {
    var train: TrainTimetable
    var startingStation: String
    var endingStation: String
    var startTime: String
    var destinationTime: String
    var tripLine: [String]
    
    func getCurrentLanguage() -> String {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        return lan
    }
    
    var body: some View {
        Group {
            ExtractedView3(startingStation: startingStation, startTime: startTime)
            ExtractedView5(endingStation: endingStation, destinationTime: destinationTime)
            if self.getCurrentLanguage() == "zh-Hant" {
                Text(NSLocalizedString("Train Type", comment: "") + ":   " + self.train.TrainInfo.TrainTypeName.Zh_tw!).font(Font.system(size: 25)) + Text("(" + tripLine[self.train.TrainInfo.TripLine!] + ")").font(Font.system(size: 25))
            }
            else {
                Text(NSLocalizedString("Train Type", comment: "") + ":   " + self.train.TrainInfo.TrainTypeName.En!).font(Font.system(size: 25)) + Text("(" + tripLine[self.train.TrainInfo.TripLine!] + ")").font(Font.system(size: 25))
            }
        }
    }
}

struct ExtractedView3: View {
    var startingStation: String
    var startTime: String
    
    var body: some View {
        Group {
            Text(NSLocalizedString("At", comment: "")).font(Font.system(size: 25)) + Text(self.startingStation).font(Font.system(size: 25)).foregroundColor(.purple) + Text(NSLocalizedString("time", comment: "") + ":   " + self.startTime).font(Font.system(size: 25))
        }
    }
}

struct ExtractedView4: View {
    var train: TrainTimetable
    var YN: [String]
    
    var body: some View {
        Group {
            Text(NSLocalizedString("Daily Train", comment: "") + ":   " + YN[self.train.TrainInfo.DailyFlag]).font(Font.system(size: 25))
            Text(NSLocalizedString("Wheel Chair Service", comment: "") + ":   " + YN[self.train.TrainInfo.WheelChairFlag]).font(Font.system(size: 25))
            Text(NSLocalizedString("Breat Feed Room", comment: "") + ":   " + YN[self.train.TrainInfo.BreastFeedFlag]).font(Font.system(size: 25))
        }
    }
}

struct ExtractedView5: View {
    var endingStation: String
    var destinationTime: String
    
    var body: some View {
        Group {
            Text("At").font(Font.system(size: 25)) + Text(self.endingStation).font(Font.system(size: 25)).foregroundColor(.purple) + Text(NSLocalizedString("time", comment: "") + ":   " + self.destinationTime).font(Font.system(size: 25))
        }
    }
}
