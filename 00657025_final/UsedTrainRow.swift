//
//  UsedTrainRow.swift
//  00657025_final
//
//  Created by User20 on 2020/6/15.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct UsedTrainRow: View {
    var train: TrainTimetable
    @State private var name: String = ""
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            name = train.TrainInfo.TrainTypeName.Zh_tw!
        }
        else {
            name = train.TrainInfo.TrainTypeName.En!
        }
    }
    
    var body: some View {
        GeometryReader { (geometry) in
            HStack {
                VStack(alignment: .leading) {
                    Text(NSLocalizedString("TrainNo", comment: "") + ": ").font(Font.system(size: 20)) + Text(self.train.TrainInfo.TrainNo).bold().font(Font.system(size: 20))
                    Text(NSLocalizedString("Train Type", comment: "") + ": ").font(Font.system(size: 20)) + Text(self.name).bold().font(Font.system(size: 20))
                }
                .padding()
                .onAppear {
                    self.getCurrentLanguage()
                }
                Spacer()
            }
            .frame(width: geometry.size.width * 400 / 414, height: geometry.size.height * 400 / 414)
            .background(LinearGradient(gradient: Gradient(colors: [Color.purple, Color.red]), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1)))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
}
