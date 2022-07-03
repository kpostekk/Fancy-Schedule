//
//  TimelineVerticalCell.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 03/07/2022.
//

import SwiftUI
import Altapi

let mockable = AltapiEntry(name: "Progamowansko", code: "GUI", type: "Ćwiczenia", begin: "2022-07-03T21:37:00", end: "2022-07-03T22:51:00", room: "A/357")

struct TimelineCell: View {
    let data: AltapiEntry
    var pixelDuration: CGFloat {
        let tDelta = data.endDate.since(data.beginDate, in: .minute)!
        return CGFloat(tDelta)
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(data.code)
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                Text(data.room)
            }
            HStack {
                Text("\(data.beginDate.formatted(date: .omitted, time: .shortened)) - \(data.endDate.formatted(date: .omitted, time: .shortened))")
            }
            
            Spacer()
        }
        .padding(.all, 5)
        .frame(maxWidth: .infinity, maxHeight: pixelDuration)
        .background(Color.init(red: 118/255, green: 142/255, blue: 168/255))
        .cornerRadius(10)
    }
}

struct TimelineHorizontalHour: View {
    let hour: Date
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            Text(hour.toString(format: .custom("HH:mm"))!)
                .font(.system(size: 14, design: .monospaced))
                .frame(maxWidth: 60)
            Rectangle()
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, maxHeight: 1)
                .padding(.bottom, 59)
        }
    }
}

struct TimelineVertical: View {
    let entries: [AltapiEntry]
    var beginTime: Date {
        entries.min(by: {
            $0.beginDate < $1.beginDate
        })!.beginDate.adjust(minute: 0)!
    }
    var countOfHours: Int {
        let minTime = entries.min(by: {
            $0.beginDate < $1.beginDate
        })!.beginDate
        let maxTime = entries.max(by: {
            $0.endDate < $1.endDate
        })!.endDate
        let hourDelta = maxTime.since(minTime, in: .hour)!
        return Int(hourDelta)
    }
    
    var body: some View {
        ZStack {
            // MARK: Time lines
            VStack(spacing: 0) {
                ForEach(0...countOfHours, id: \.self) { i in
                    TimelineHorizontalHour(hour: beginTime.offset(.hour, value: i)!)
                }
                // DO NOT FUCKING TOUCH THIS
                /* PLEASE NO */ Spacer() // DO NOT FUCKING REMOVE THIS SPACER GOD PLEASE NO
                // DO NOT EVEN TRY TO PISS ME OFF
            }
            
            // MARK: Entires
            ZStack {
                ForEach(entries) { entry in
                    VStack(spacing: 0) {
                        TimelineCell(data: entry)
                            .padding(.top, CGFloat(entry.beginDate.since(beginTime, in: .minute)!))
                        Spacer()
                    }
                }
                
            }
            .frame(maxHeight: .infinity)
            .padding(.leading, 65)
            .padding(.trailing, 5)
        }
    }
}

struct TimelineVerticalCell_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack(alignment: .leading) {
            List {
                TimelineVertical(
                    entries: [mockable]
                )
                .padding(.vertical, 20)
                .border(.green)
            }
        }
    }
}
