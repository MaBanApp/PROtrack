//
//  ProgressBar.swift
//  PROtrack
//
//  Created by Marino Bantli on 07.05.20.
//  Copyright © 2020 MB-Apps. All rights reserved.
//

import SwiftUI


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
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}

//Helperclass for time and progress calculation
class progressService {
    
    func getProgress(guideTime: String, bookedTime: [TimeRecords]) -> Float {
        var time: Int = 0
        let guide: Int = Int(guideTime)!
        
        if bookedTime.count == 0 {
            return Float(0)
        }
        else
        {
            for index in (0...bookedTime.count - 1) {
                time = time + Int(bookedTime[index].time)!
            }
        }

        return Float(time) / Float(guide)
    }
    
    func getBookedTime(bookedTime: [TimeRecords]) -> String {
        var time: Int = 0
        
        if bookedTime.count == 0 {
            return "---"
        }
        else
        {
            for index in (0...bookedTime.count - 1) {
                time = time + Int(bookedTime[index].time)!
            }
        }

        
        return String(String(time) + " Minuten")
    }
  
    func getTotalGuideTime(timeRecords: [TaskPayload]) -> String {
        var time: Int = 0
        
        if timeRecords.count == 0 {
            return "0"
        }
        else
        {
            for index in (0...timeRecords.count - 1) {
                time = time + Int(timeRecords[index].guide_time)!
            }
        }

        
        return String(String(time))
    }
    
    func getTotalBookedTime(timeRecords: [TaskPayload]) -> String {
        var time: Int = 0
        
        if timeRecords.count >= 1 {
            for index in (0...timeRecords.count - 1) {
                if timeRecords[index].records.count == 0 {
                    return "0"
                }
                else
                {
                    for i in (0...timeRecords[index].records.count - 1) {
                        time = time + Int(timeRecords[index].records[i].time)!
                    }
                }
            }
        }
        else
        {
            return "0"
        }
        

        return String(time)
    }

}
