//
//  TimelineVerticalCell.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 03/07/2022.
//

import SwiftUI
import Altapi

let mockable = AltapiEntry(name: "GUI", code: "GUI", type: "Ćwiczenia", begin: "2022-07-03T14:25:47", end: "2022-07-03T15:55:47", room: "A/357")

struct TimelineCell: View {
    let data: AltapiEntry
    var pixelDuration: CGFloat {
        let tDelta = data.endDate.since(data.beginDate, in: .minute)!
        return CGFloat(tDelta)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(data.name)
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

struct TimelineVertical: View {
    let count: Int
    let beginTime: Date
    let entries: [AltapiEntry]
    
    var body: some View {
        ZStack {
            // MARK: Time lines
            VStack(spacing: 0) {
                ForEach(0..<count, id: \.self) { i in
                    HStack(alignment: .top, spacing: 0) {
                        Text(beginTime.offset(.hour, value: i)!.toString(format: .custom("HH:mm"))!)
                            .font(.system(size: 14, design: .monospaced))
                            .frame(maxWidth: 60)
                        Rectangle()
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, maxHeight: 1)
                            .padding(.bottom, 59)
                    }
                }
                Spacer()
            }
            
            // MARK: Entires
            ZStack(alignment: .top) {
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
            
            
            //.padding(.horizontal)
        }
    }
}

struct TimelineVerticalCell_Previews: PreviewProvider {
    
    static var previews: some View {
        VStack {
            List {
                TimelineVertical(
                    count: 10,
                    beginTime: Date().adjust(hour: 14, minute: 0, second: 0)!,
                    entries: [mockable]
                )
                .padding(.vertical, 20)
                .border(.green)
            }
        }
    }
}
