# WeatherDress

A minimalistic iOS app that fetches the current weather and suggests what to wear. The project also includes a simple WidgetKit extension for at-a-glance advice.

## Features
- Fetches weather data from the [Open‑Meteo](https://open-meteo.com/) API (no key required)
- Clean SwiftUI interface
- Widget for quick clothing tips
- Configurable latitude and longitude in `WeatherService`

## Building
1. Open the `WeatherDressApp` folder in Xcode (iOS 15+).
2. Add the files to a new iOS app project or Swift package.
3. Build and run on a simulator or device.

## Note
The project compiles only on macOS with Xcode because it uses SwiftUI and WidgetKit. Running `swiftc` on Linux will fail as those frameworks are unavailable.
