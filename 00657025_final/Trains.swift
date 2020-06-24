//
//  Trains.swift
//  00657025_final
//
//  Created by User23 on 2020/6/6.
//  Copyright © 2020 User23. All rights reserved.
//

import Foundation

struct TRADailyTrainTimeTableList: Codable {
    var TrainTimetables: [TrainTimetable]
}

struct TrainTimetable: Codable {
    var TrainInfo: TrainInfo
    var StopTimes: [StopTime]
}

struct TrainInfo: Codable {
    var TrainNo: String
    var TrainTypeName: NameType
    var TripHeadSign: String?
    var StartingStationName: NameType
    var EndingStationName: NameType
    var TripLine: Int?
    var WheelChairFlag: Int
    var BreastFeedFlag: Int
    var BikeFlag: Int
    var DailyFlag: Int
    var ExtraTrainFlag: Int
}

struct StopTime: Codable {
    var StopSequence: Int
    var StationName: NameType
    var ArrivalTime: String? //HH:mm
    var DepartureTime: String? //HH:mm
}

struct NameType: Codable {
    var Zh_tw: String?
    var En: String?
}

class TRADailyTrainTimeTableListsData: ObservableObject {
    @Published var TRADailyTrainTimeTableLists = [TRADailyTrainTimeTableList]()
}

class TrainTimetablesData: ObservableObject {
    @Published var trainData = [TrainTimetable]()
}
