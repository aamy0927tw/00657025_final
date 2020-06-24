//
//  UsedTrainsList.swift
//  00657025_final
//
//  Created by User20 on 2020/6/15.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct UsedTrainsList: View {
    @State private var number: String = ""
    @EnvironmentObject var TRADailyTrainTimeTableLists: TRADailyTrainTimeTableListsData
    @ObservedObject var usedTrains = TrainTimetablesData()
    @State private var showAlert: Bool = false
    @State private var state: Int = 0
    
    func show_Alert(number: String) -> Bool {
        if TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists.count == 0 {
            state = 0
            return true
        }
        for train in TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists[0].TrainTimetables {
            if train.TrainInfo.TrainNo == number {
                return false
            }
        }
        state = 1
        return true
    }
    
    func searchTrain(number: String) -> TrainTimetable {
        for train in TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists[0].TrainTimetables {
            if train.TrainInfo.TrainNo == number {
                return train
            }
        }
        return TRADailyTrainTimeTableLists.TRADailyTrainTimeTableLists[0].TrainTimetables[0]
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    HStack {
                        TextField(NSLocalizedString("Input TrainNo", comment: ""), text: self.$number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button(action: {
                            self.showAlert = self.show_Alert(number: self.number)
                            if self.showAlert == false {
                                let train = self.searchTrain(number: self.number)
                                self.usedTrains.trainData.insert(train, at: 0)
                            }
                        }, label: {
                            Image(systemName: "magnifyingglass")
                            }).offset(x: -8, y: 0)
                    }.padding()
                    .alert(isPresented: self.$showAlert) { () -> Alert in
                        if self.state == 0 {
                            return Alert(title: Text(NSLocalizedString("No Data!", comment: "")))
                        }
                        else {
                            return Alert(title: Text(NSLocalizedString("Can't find the train.", comment: "")))
                        }
                    }
                    Text(NSLocalizedString("Common Use", comment: "")).font(Font.system(size: 35)).bold()
                    List {
                        ForEach(self.usedTrains.trainData.indices, id: \.self) { (index) in
                            NavigationLink(destination: UsedTrainDetail(train: self.usedTrains.trainData[index])) {
                                UsedTrainRow(train: self.usedTrains.trainData[index])
                                    .frame(height: geometry.size.height * 45 / 414)
                            }
                        }
                        .onDelete { (indexSet) in
                            self.usedTrains.trainData.remove(atOffsets: indexSet)
                        }
                    }
                }
            }
        }
    }
}
