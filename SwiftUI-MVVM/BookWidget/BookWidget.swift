//
//  BookWidget.swift
//  BookWidget
//
//  Created by 이서준 on 3/7/24.
//

import WidgetKit
import SwiftUI

// TODO: AppIntentTimelineProvider vs TimelineProvider
struct Provider: TimelineProvider {
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entries: [SimpleEntry] = []
        
        let currentDate = Date()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    //let configuration: ConfigurationAppIntent
}

struct BookWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Time:")
            Text(entry.date, style: .time)

            Text("Favorite Emoji:")
            //Text(entry.configuration.favoriteEmoji)
        }
    }
}

@main
struct BookWidget: Widget {
    let kind: String = "BookWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BookWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Book Widget")
        .description("This is an book widget")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//    
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}

#Preview(as: .systemSmall) {
    BookWidget()
} timeline: {
    SimpleEntry(date: .now) //, configuration: .smiley)
    SimpleEntry(date: .now) //, configuration: .starEyes)
}
