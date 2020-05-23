//
//  ProgressBar.swift
//  PROtrack
//
//  Created by Marino Bantli on 07.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI


struct ProgressView: View {
    
    //Data vars
    @Binding var guideTime        : Int
    @Binding var bookedTime       : Int
    @State private var progress   : Float = 0.00
        
    var body: some View {
        VStack{
            HStack{
                Text("Richtzeit:")
                Spacer()
                Text("\(guideTime) Minuten")
            }
            HStack {
                Text("Verbuchte Zeit:")
                Spacer()
                Text("\(bookedTime ) Minuten")
            }
            ProgressBar(value: $progress).frame(height:10)
        }.frame(height: 70)
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if !((self.bookedTime == 0) && self.guideTime == 0) {
                    self.progress = Float(self.bookedTime) / Float(self.guideTime)
                }
            }
        }
        
    }

}

struct ProgressBar: View {
    
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(self.value <= 1 ? Color(UIColor.systemBlue) : Color(UIColor.systemRed))
                    .animation(.easeOut(duration: 0.6))
            }.cornerRadius(45.0)
        }
    }
}

//Helperclass for time and progress calculation
class progressService {
    
    func getBookedTime(bookedTime: [TimeRecords]) -> Int {
        var time: Int = 0
        
        if bookedTime.count == 0 {
            return 0
        }
        else
        {
            for index in (0...bookedTime.count - 1) {
                time = time + bookedTime[index].time
            }
        }

        
        return time
    }
  
    func getTotalGuideTime(timeRecords: [TaskPayload]) -> Int {
        var time: Int = 0
        
        if timeRecords.count == 0 {
            return 0
        }
        else
        {
            for index in (0...timeRecords.count - 1) {
                time = time + timeRecords[index].guide_time
            }
        }

        
        return time
    }
    
    func getTotalBookedTime(timeRecords: [TaskPayload]) -> Int {
        var time: Int = 0
        if timeRecords.count >= 1 {
            for index in timeRecords.indices {
                for i in timeRecords[index].records.indices {
                    time = time + timeRecords[index].records[i].time
                }
            }
        }
        else
        {
            return 0
        }
        return time
    }
}
