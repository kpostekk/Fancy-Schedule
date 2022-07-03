//
//  ContentView.swift
//  Fancy Schedule
//
//  Created by Krystian Postek on 27/06/2022.
//

import Altapi
import DateHelper
import SwiftUI

var beginDate = Date(fromString: "2022-03-11", format: .isoDate)!
let httpConfFactory = {
    let httpConf = URLSessionConfiguration.default
    httpConf.requestCachePolicy = .returnCacheDataElseLoad
    return httpConf
}

let http = URLSession(configuration: httpConfFactory())

struct AltapiDay: Identifiable, Equatable {
    static func == (lhs: AltapiDay, rhs: AltapiDay) -> Bool {
        lhs.id == rhs.id && lhs.entries == rhs.entries
    }

    let id = UUID()
    let date: Date
    let entries: [AltapiEntry]
}

// @MainActor
class DataSource: ObservableObject {
    @Published var days: [AltapiDay] = []
    @Published var isLoading = false

    @MainActor
    func proxiedLoadContent(currentItem item: AltapiDay?) async {
        guard item != nil else {
            isLoading = true
            let result = (try? await loadMoreDays(28)) ?? []
            days += result
            isLoading = false
            return
        }

        let isLastElement = days.last == item
        if isLastElement {
            isLoading = true
            let result = (try? await loadMoreDays(7)) ?? []
            days += result
            isLoading = false
        }
    }

    private func loadMoreDays(_ loadSize: Int = 1, _ backlogSize: Int = 0) async throws -> [AltapiDay] {
        var url = URL(string: "https://altapi.kpostek.dev/v1/timetable/range")!

        let groups = ["WIs I.2 - 46c", "WIs I.2 - 1w", "WIs I.2 - 126l"].map {
            URLQueryItem(name: "groups", value: $0)
        }
        let from = URLQueryItem(name: "from", value: beginDate.offset(.day, value: backlogSize * -1)!.toString(format: .isoDateTime, timeZone: .utc))
        let to = URLQueryItem(name: "to", value: beginDate.offset(.day, value: loadSize)!.adjust(for: .endOfDay)!.toString(format: .isoDateTime, timeZone: .utc))
        let queries = [from, to] + groups

        if #available(iOS 16, *) {
            url.append(queryItems: queries)
        } else {
            var urlComp = URLComponents(string: "https://altapi.kpostek.dev/v1/timetable/range")!
            urlComp.queryItems = queries
            url = urlComp.url!
        }

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        let json = try JSONDecoder().decode(AltapiEntryResponse.self, from: data)
        let responseDays = Dictionary(grouping: json.entries, by: {
            Date(detectFromString: $0.begin)!.toString(format: .isoDate)!
        })
        beginDate = beginDate.offset(.day, value: loadSize)!
        return responseDays.keys.sorted().map {
            .init(date: Date(fromString: $0, format: .isoDate)!, entries: responseDays[$0]!)
        }
    }
}

struct ContentView: View {
    @StateObject var dataSource = DataSource()
    
    init() {
        UITableView.appearance().showsVerticalScrollIndicator = false
    }

    var body: some View {
        TabView {
            VStack {
                if #available(iOS 16.0, *) {
                    List {
                        ForEach(dataSource.days) { it in
                            Section(it.date.formatted(date: .complete, time: .omitted)) {
                                ForEach(it.entries) { e in
                                    EntryCell(entry: .constant(e))
                                }
                            }
                            .task {
                                await dataSource.proxiedLoadContent(currentItem: it)
                            }
                        }
                        if dataSource.isLoading {
                            VStack(alignment: .center) {
                                ProgressView()
                                Text("Ładowanie kolejnego tydodnia")
                                    .italic()
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    .scrollIndicators(.never)
                } else {
                    List {
                        ForEach(dataSource.days) { it in
                            Section(it.date.formatted(date: .abbreviated, time: .omitted)) {
                                ForEach(it.entries) { e in
                                    EntryCell(entry: .constant(e))
                                }
                                if dataSource.isLoading {
                                    ProgressView()
                                }
                            }
                            .task {
                                await dataSource.proxiedLoadContent(currentItem: it)
                            }
                        }
                    }
                }
            }.tabItem {
                Label("Inifnite scroll", systemImage: "list.dash")
            }
            VStack {
                TabView {
                    ForEach(dataSource.days) { it in
                        VStack {
                            Text(it.date.formatted(date: .complete, time: .omitted)).font(.title2)
                            List(it.entries) {
                                EntryCell(entry: .constant($0))
                            }.task {
                                await dataSource.proxiedLoadContent(currentItem: it)
                            }
                        }
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }.tabItem {
                Label("Infnite book", systemImage: "book")
            }
            VStack {
                ScrollView {
                    TimelineVertical(count: 8, beginTime: Date(detectFromString: "2022-07-03T14:00:00")!, entries: [mockable])
                        .padding(.vertical)
                        .background(.secondary.opacity(0.3))
                        .cornerRadius(10)
                }
            }.tabItem {
                Label("aaaaa", image: "jebacsmyka")
            }
        }.task {
            await dataSource.proxiedLoadContent(currentItem: nil)
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
