import WidgetKit
import SwiftUI

struct WeatherDressEntry: TimelineEntry {
    let date: Date
    let weather: Weather
    let advice: String
}

struct WeatherProvider: TimelineProvider {
    let service = WeatherService()
    func placeholder(in context: Context) -> WeatherDressEntry {
        WeatherDressEntry(date: Date(), weather: Weather(temperature: 20, condition: "Clear", rainProbability: 0), advice: "Short sleeves are fine.")
    }

    func getSnapshot(in context: Context, completion: @escaping (WeatherDressEntry) -> Void) {
        completion(placeholder(in: context))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<WeatherDressEntry>) -> Void) {
        Task {
            let weather = try? await service.fetchWeather()
            let entry = WeatherDressEntry(date: Date(), weather: weather ?? placeholder(in: context).weather, advice: WeatherViewModel().advice(for: weather ?? placeholder(in: context).weather))
            completion(Timeline(entries: [entry], policy: .after(Date().addingTimeInterval(60*60))))
        }
    }
}

struct WeatherDressWidgetEntryView : View {
    var entry: WeatherProvider.Entry

    var body: some View {
        VStack {
            Text("\(Int(entry.weather.temperature))°")
                .font(.title)
            Text(entry.advice)
                .font(.caption)
        }
        .padding()
    }
}

@main
struct WeatherDressWidget: Widget {
    let kind: String = "WeatherDressWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: WeatherProvider()) { entry in
            WeatherDressWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("How to Dress")
        .description("Shows clothing suggestion based on the weather.")
        .supportedFamilies([.systemSmall])
    }
}
