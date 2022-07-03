//
//  EntryCell.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 03/07/2022.
//

import SwiftUI
import Altapi

struct EntryCell: View {
    @Binding var entry: AltapiEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(entry.code)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
            Text(entry.name)
                .font(.system(size: 10))
            HStack {
                Text("od")
                Text(entry.beginDate.formatted(date: .omitted, time: .shortened))
                Text("do")
                Text(entry.endDate.formatted(date: .omitted, time: .shortened))
            }
            
        }
    }
}

struct EntryCell_Previews: PreviewProvider {
    static var previews: some View {
        List {
            EntryCell(entry: .constant(AltapiEntry(name: "Programowanie Obiektowe w Javie", code: "GUI", type: "Ćwiczenia", begin: "2022-07-03T10:08:06.594040", end: "2022-07-03T10:08:08.933771")))
            EntryCell(entry: .constant(AltapiEntry(name: "Programowanie Obiektowe w Javie", code: "GUI", type: "Ćwiczenia", begin: "2022-07-03T10:08:06.594040", end: "2022-07-03T10:08:08.933771")))
            EntryCell(entry: .constant(AltapiEntry(name: "Programowanie Obiektowe w Javie", code: "GUI", type: "Ćwiczenia", begin: "2022-07-03T10:08:06.594040", end: "2022-07-03T10:08:08.933771")))
            
        }
    }
}
