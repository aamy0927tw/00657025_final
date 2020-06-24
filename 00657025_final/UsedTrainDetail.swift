//
//  UsedTrainDetail.swift
//  00657025_final
//
//  Created by User20 on 2020/6/15.
//  Copyright © 2020 User23. All rights reserved.
//

import SwiftUI

struct UsedTrainDetail: View {
    @State private var showSheet: Bool = false
    var train: TrainTimetable
    var tripLine = [NSLocalizedString("Neither", comment: ""), NSLocalizedString("Mountain", comment: ""), NSLocalizedString("Coast", comment: "")]
    var YN = [NSLocalizedString("No", comment: ""), NSLocalizedString("Yes", comment: "")]
    @State var sSta: String = ""
    @State var eSta: String = ""
    @State private var selectImage: UIImage?
    @State private var showSelectPhoto = false
    
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
        VStack {
            ExtractedView7(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
            Text(self.train.TrainInfo.TrainNo).font(Font.system(size: 50)).fontWeight(.heavy) + Text(" ." + NSLocalizedString("Train", comment: "")).font(Font.system(size: 28))
            Text(NSLocalizedString("From", comment: "") + " ").font(Font.system(size: 22)) + Text(self.sSta).font(Font.system(size: 28)).foregroundColor(.red).underline() + Text(" " + NSLocalizedString("to", comment: "") + " ").font(Font.system(size: 22)) + Text(self.eSta).font(Font.system(size: 28)).foregroundColor(.red).underline()
            ExtractedView6(train: train, tripLine: tripLine)
        }.padding()
        .onAppear {
            self.getCurrentLanguage()
        }
        .navigationBarTitle(NSLocalizedString("Details", comment: ""))
    }
}

struct ExtractedView6: View {
    var train: TrainTimetable
    var tripLine: [String]
    @State var type: String = ""
    
    func getCurrentLanguage() {
        let array = Bundle.main.preferredLocalizations
        let lan = array[0]
        if lan == "zh-Hant" {
            type = train.TrainInfo.TrainTypeName.Zh_tw!
        }
        else {
            type = train.TrainInfo.TrainTypeName.En!
        }
    }
    
    var body: some View {
        Group {
            Text(NSLocalizedString("Departure Time", comment: "") + ": ").font(Font.system(size: 28)) + Text(self.train.StopTimes[0].DepartureTime!).font(Font.system(size: 28))
            Text(NSLocalizedString("Train Type", comment: "") + ":   " + self.type).font(Font.system(size: 25))
            Text("(" + tripLine[self.train.TrainInfo.TripLine!] + ")").font(Font.system(size: 25))
        }
        .onAppear {
            self.getCurrentLanguage()
        }
    }
}

struct ExtractedView7: View {
    @Binding var selectImage: UIImage?
    @Binding var showSelectPhoto: Bool
    
    var body: some View {
        Group {
            Button(action: {
                self.showSelectPhoto = true
            }) {
                if selectImage != nil {
                    Image(uiImage: selectImage!)
                        .resizable()
                        .renderingMode(.original)
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipped()
                }
                else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 300, height: 300)
                        .clipped()
                }
            }
            .buttonStyle(PlainButtonStyle())
            .sheet(isPresented: $showSelectPhoto) {
                ImagePickerController(selectImage: self.$selectImage, showSelectPhoto: self.$showSelectPhoto)
            }
        }
    }
}
