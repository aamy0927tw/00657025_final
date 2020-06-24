//
//  TrainList.swift
//  00657025_final
//
//  Created by User17 on 2020/6/9.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI
import CryptoKit
import Foundation

struct TrainList: View {
    @EnvironmentObject var TRADailyTrainTimeTableLists: TRADailyTrainTimeTableListsData
    @Environment(\.presentationMode) var presentationMode
    @State private var trains = [TrainTimetable]()
    
    @Binding var startingStation: String
    @Binding var endingStation: String
    @Binding var startTimeHour: String
    @Binding var startTimeMin: String
    @Binding var endTimeHour: String
    @Binding var endTimeMin: String
    
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    func fetchTrains() {
        let appID = "3843eaf632254c3cbfc10663139b50a0"
        let appKey = "2Y-mXUKppK6hdwB0DvAyu9rtlhY"
        let xDate = getTimeString()
        let signDate = "x-date: \(xDate)"
        let key = SymmetricKey(data: Data(appKey.utf8))
        let hmac = HMAC<SHA256>.authenticationCode(for: Data(signDate.utf8), using: key)
        let base64HmacString = Data(hmac).base64EncodedString()
        let authorization = """
        hmac username="\(appID)", algorithm="hmac-sha256", headers="x-date", signature="\(base64HmacString)"
        """
        let url = URL(string: "https://ptx.transportdata.tw/MOTC/v3/Rail/TRA/DailyTrainTimetable/Today?$format=JSON")!
        var request = URLRequest(url: url)
        request.setValue(xDate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(String(data: data!, encoding: .utf8) as Any)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            DispatchQueue.main.async {
                if let data = data, let train = try? decoder.decode(TRADailyTrainTimeTableList.self, from: data) {
                    self.TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists.append(train)
                    //print(self.TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists.count)
                }
                
                for tra in self.TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists[0].TrainTimetables {
                    if self.judgeTrain(tra: tra, startLoc: self.startingStation, endLoc: self.endingStation, startHour: self.startTimeHour, startMin: self.startTimeMin, endHour: self.endTimeHour, endMin: self.endTimeMin) == true {
                        self.trains.append(tra)
                    }
                }
            }
            
        }.resume()
    }
    
    func judgeTrain(tra: TrainTimetable, startLoc: String, endLoc: String, startHour: String, startMin: String, endHour: String, endMin: String) -> Bool {
        var condition: Int = 0
        var tempStr: [String] = [""]
        var stopTime: Int = 0
        var userStartTime: Int = 0
        var userEndTime: Int = 0
        
        for stop in tra.StopTimes {
            if stop.StationName.Zh_tw! == startLoc || stop.StationName.En! == startLoc{
                condition = condition + 1
//                print("1: " + stop.StationName.Zh_tw! + "." + startLoc)
                tempStr = stop.ArrivalTime!.components(separatedBy: ":")
                print("tempStr: " + tempStr[0] + "." + tempStr[1])
                stopTime = Int(tempStr[0])! * 100 + Int(tempStr[1])!
                print("stopTime: " + String(stopTime))
                userStartTime = Int(startHour)! * 100 + Int(startMin)!
                print("userStart: " + String(userStartTime))
                userEndTime = Int(endHour)! * 100 + Int(endMin)!
                print("userEnd: " + String(userEndTime))
                if stopTime >= userStartTime && stopTime <= userEndTime {
                    condition = condition + 1
//                    print("2")
                }
            }
            if (stop.StationName.Zh_tw! == endLoc || stop.StationName.En! == endLoc) && condition > 0 {
                condition = condition + 1
//                print("3: " + stop.StationName.Zh_tw! + "." + endLoc)
            }
        }
        print("condition = " + String(condition))
        if condition == 3 {
            print("****************true")
            return true
        }
        else {
            print("--------------false")
            return false
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            List(self.trains.indices, id: \.self) { (index) in
                HStack {
                    NavigationLink(destination: TrainDetail(startingStation: self.$startingStation, endingStation: self.$endingStation, train: self.trains[index])) {
                        HStack {
                            TrainRow(startingStation: self.$startingStation, endingStation: self.$endingStation, train: self.trains[index])
                                .frame(height: geometry.size.height * 45 / 414)
                        }
                    }.navigationBarTitle(NSLocalizedString("Results", comment: ""))
                }
            }
            .onAppear {
                if self.trains.count == 0 {
                    self.fetchTrains()
                }
            }
        }
    }
}
