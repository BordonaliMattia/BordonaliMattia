import Foundation

struct Weather: Decodable {
    let temperature: Double
    let condition: String
    let rainProbability: Double
}

final class WeatherService {
    func fetchWeather() async throws -> Weather {
        // Replace with your favorite API. Example uses open-meteo.com which requires no key.
        let url = URL(string: "https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current_weather=true")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        return Weather(temperature: decoded.currentWeather.temperature, condition: decoded.currentWeather.weathercodeDescription, rainProbability: decoded.currentWeather.precipitationProbability)
    }
}

private struct OpenMeteoResponse: Decodable {
    let currentWeather: CurrentWeather

    enum CodingKeys: String, CodingKey {
        case currentWeather = "current_weather"
    }
}

private struct CurrentWeather: Decodable {
    let temperature: Double
    let weathercode: Int
    let precipitationProbability: Double

    enum CodingKeys: String, CodingKey {
        case temperature
        case weathercode
        case precipitationProbability = "precipitation_probability"
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
