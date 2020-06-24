//
//  StationList.swift
//  00657025_final
//
//  Created by User23 on 2020/6/6.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI
import CryptoKit
import PartialSheet

struct StationList: View {
    @EnvironmentObject var partialSheetManager: PartialSheetManager
    @State private var stationsList = [TRAStationList]()
    @State private var stations = [Station]()
    @ObservedObject var currentStations = StationData()
    @State private var tempStations = [Station]()
    @State private var currentDistrict = "All"
    @State private var tempDistrict = ""
    @State private var districtsEn = ["Keelung", "New Taipei", "Taipei", "Taoyuan", "Hsinchu", "Miaoli", "Taichung", "Changhua", "Yunlin", "Chiayi", "Tainan", "Kaohsiung", "Pingtung", "Taitung", "Yilan", "Hualien"]
    @State private var districtTw = ["基隆", "新北", "臺北", "桃園", "新竹", "苗栗", "臺中", "彰化", "雲林", "嘉義", "臺南", "高雄", "屏東", "臺東", "宜蘭", "花蓮"]
    @State private var district = [""]
    
    func getCurrentLanguage() -> String {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        return lan
    }
    
    func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ww zzz"
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        let time = dateFormatter.string(from: Date())
        return time
    }
    
    func fetchStations() {
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
        let url = URL(string: "https://ptx.transportdata.tw/MOTC/v3/Rail/TRA/Station?$format=JSON")!
        var request = URLRequest(url: url)
        request.setValue(xDate, forHTTPHeaderField: "x-date")
        request.setValue(authorization, forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            //print(String(data: data!, encoding: .utf8) as Any)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            DispatchQueue.main.async {
                if let data = data, let station = try? decoder.decode(TRAStationList.self, from: data) {
                    self.stationsList.append(station)
                }
                for sta in self.stationsList[0].Stations {
                    if Int(sta.StationClass!)! < 3 {
                        self.stations.append(sta)
                    }
                }
                self.currentStations.stationData = self.stations
            }
        }.resume()
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    List(self.currentStations.stationData.indices, id: \.self) { (index) in
                        NavigationLink(destination: StationDetail(station: self.currentStations.stationData[index])) {
                            StationRow(station: self.currentStations.stationData[index])
                                .frame(height: geometry.size.height * 25 / 414)
                        }
                    }
                    .onAppear {
                        if self.stations.count == 0 {
                            self.fetchStations()
                        }
                        UITableView.appearance().separatorColor = .clear
                    }
                }
                .navigationBarTitle(NSLocalizedString(self.currentDistrict, comment: "") + NSLocalizedString("Stations", comment: ""))
                .navigationBarItems(trailing: Button(action: {
                    self.partialSheetManager.showPartialSheet( {
                        print("normal sheet dismissed")
                    }) {
                        if self.getCurrentLanguage() == "zh-Hant" {
                            SheetView(districts: self.$districtTw, tempDistrict: self.$tempDistrict, currentDistrict: self.$currentDistrict, stations: self.$stations, tempStations: self.$tempStations, currentStations: self.currentStations)
                        }
                        else {
                            SheetView(districts: self.$districtsEn, tempDistrict: self.$tempDistrict, currentDistrict: self.$currentDistrict, stations: self.$stations, tempStations: self.$tempStations, currentStations: self.currentStations)
                        }
                    }
                }, label: {
                    Text(NSLocalizedString("Select area", comment: ""))
                }))
            }.addPartialSheet()
        }
    }
}

struct StationList_Previews: PreviewProvider {
    static var previews: some View {
        StationList()
    }
}

struct SheetView: View {
    @Binding var districts: [String]
    @Binding var tempDistrict: String
    @Binding var currentDistrict: String
    @Binding var stations: [Station]
    @Binding var tempStations: [Station]
    var currentStations: StationData
    
    func judgeDistrict() {
        if self.currentDistrict == "All area" {
            self.currentStations.stationData = self.stations
        }
        else {
            self.tempStations.removeAll()
            self.currentStations.stationData.removeAll()
            for station in self.stations {
                let address = station.StationAddress!
                var temp: [String]
                var zone: String
                temp = address.components(separatedBy: "縣")
                if temp[0].count > 7 {
                    temp = address.components(separatedBy: "市")
                }
                zone = String(temp[0].suffix(2))
                if zone == self.currentDistrict {
                    self.tempStations.insert(station, at: 0)
                }
            }
            self.currentStations.stationData = self.tempStations
        }
    }
    
    var body: some View {
        VStack {
            Button(action: {
                self.currentDistrict = self.tempDistrict
                self.judgeDistrict()
            }, label: {
                Text("OK")
            })
            Picker(selection: $tempDistrict, label: Text("Select area")) {
                ForEach(0..<self.districts.count) { (index) in
                    Text(self.districts[index]).tag(self.districts[index])
                }
            }
        }
    }
}
