//
//  TimelineVerticalCell.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 03/07/2022.
//

import SwiftUI

struct SomeCell: View {
    let pixelDuration: CGFloat
    
    var body: some View {
        VStack {

        }
        .padding(.all)
        .frame(maxWidth: .infinity, maxHeight: pixelDuration)
        .border(.black)
        .background(.white)
        .cornerRadius(10)
    }
}

struct TimelineVertical: View {
    let count: Int
    let beginTime: Date
    
    var body: some View {
        ZStack {
            // MARK: Time lines
            VStack(spacing: 0) {
                ForEach(0..<count, id: \.self) { i in
                    HStack(alignment: .top, spacing: 0) {
                        Text(beginTime.offset(.hour, value: i)!.toString(format: .custom("HH:MM"))!)
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
                VStack(spacing: 0) {
                    SomeCell(pixelDuration: 90)
                        .padding(.top, 0)
                    Spacer()
                }
                VStack(spacing: 0) {
                    SomeCell(pixelDuration: 180)
                        .padding(.top, 120)
                    Spacer()
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
                TimelineVertical(count: 10, beginTime: .now)
                    .padding(.vertical, 20)
                    .border(.green)
            }
        }
    }
}
