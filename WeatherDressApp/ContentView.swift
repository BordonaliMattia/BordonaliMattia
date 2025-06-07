import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        VStack(spacing: 16) {
            if let weather = viewModel.weather {
                Text("\(Int(weather.temperature))°")
                    .font(.system(size: 64, weight: .thin))
                Text(weather.condition)
                    .font(.headline)
                Text(viewModel.advice(for: weather))
                    .font(.subheadline)
                    .padding(.top)
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.load()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
