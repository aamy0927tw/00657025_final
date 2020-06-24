//
//  TrainStation.swift
//  00657025_final
//
//  Created by User23 on 2020/6/6.
//  Copyright © 2020 User23. All rights reserved.
//

import Foundation

struct TRAStationList: Codable {
    var Stations: [Station]
}

struct Station: Codable {
    var StationID: String
    var StationName: NameType
    var StationPosition: PointType
    var StationAddress: String?
    var StationPhone: String?
    var StationClass: String?
    var StationURL: String?
}

struct PointType: Codable {
    var PositionLat: Double?
    var PositionLon: Double?
}

class StationData: ObservableObject {
    @Published var stationData = [Station]()
}
