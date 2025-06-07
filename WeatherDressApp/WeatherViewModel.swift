import Foundation
import SwiftUI

@MainActor
final class WeatherViewModel: ObservableObject {
    @Published var weather: Weather?
    private let service = WeatherService()

    func load() async {
        do {
            weather = try await service.fetchWeather()
        } catch {
            print("Failed to fetch weather: \(error)")
        }
    }

    func advice(for weather: Weather) -> String {
        var result = ""
        if weather.temperature < 10 {
            result = "Wear a coat."
        } else if weather.temperature < 20 {
            result = "Wear a jacket."
        } else {
            result = "Short sleeves are fine."
        }
        if weather.rainProbability > 0.5 {
            result += " Bring an umbrella."
        }
        return result
    }
}
