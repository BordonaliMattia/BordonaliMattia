import Foundation

struct Weather: Decodable {
    let temperature: Double
    let condition: String
    let rainProbability: Double
}

final class WeatherService {
    private let latitude: Double
    private let longitude: Double

    init(latitude: Double = 52.52, longitude: Double = 13.41) {
        self.latitude = latitude
        self.longitude = longitude
    }

    func fetchWeather() async throws -> Weather {
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current_weather=true&hourly=precipitation_probability")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        let precipProb = decoded.hourly.precipitationProbability.first ?? 0
        return Weather(
            temperature: decoded.currentWeather.temperature,
            condition: decoded.currentWeather.weathercodeDescription,
            rainProbability: precipProb / 100
        )
    }
}

private struct OpenMeteoResponse: Decodable {
    let currentWeather: CurrentWeather
    let hourly: Hourly

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
        case hourly
    }
}

private struct Hourly: Decodable {
    let precipitationProbability: [Double]

    enum CodingKeys: String, CodingKey {
        case precipitationProbability = "precipitation_probability"
    }
}

private struct CurrentWeather: Decodable {
    let temperature: Double
    let weathercode: Int

    enum CodingKeys: String, CodingKey {
        case temperature
        case weathercode
    }

    var weathercodeDescription: String {
        switch weathercode {
        case 0: return "Clear"
        case 1,2,3: return "Partly Cloudy"
        case 45,48: return "Fog"
        case 51,53,55: return "Drizzle"
        case 61,63,65: return "Rain"
        case 71,73,75: return "Snow"
        default: return ""
        }
    }
}
