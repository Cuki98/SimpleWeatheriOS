# SimpleWeatherApp

A minimalistic and beautiful iOS weather application built with SwiftUI, following the MVVM (Model-View-ViewModel) architecture.

## Features
- Real-time weather updates
- City selection
- Clean and modern UI
- SwiftUI and MVVM architecture

## Project Structure
```
SimpleWeatherApp/
├── Models/
│   └── Weather.swift
├── ViewModels/
│   └── WeatherViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── MinimalisticWeatherView.swift
│   ├── WeatherCitySelectetorView.swift
│   └── WeatherView.swift
├── Utils/
│   ├── SimpleWeatherAppApp.swift
│   └── StringExtension.swift
├── Assets.xcassets/
├── Preview Content/
```

## MVVM Architecture
- **Model:** Handles the data and business logic (e.g., `Weather.swift`).
- **View:** SwiftUI views for displaying UI (e.g., `ContentView.swift`, `WeatherView.swift`).
- **ViewModel:** Connects the Model and View, providing data and logic for the UI (e.g., `WeatherViewModel.swift`).

## Getting Started
1. Clone the repository:
   ```sh
   git clone https://github.com/Cuki98/SimpleWeatheriOS.git
   ```
2. Open `SimpleWeatherApp.xcodeproj` in Xcode.
3. Build and run on your simulator or device.

## Screenshots
<!-- Add screenshots of your app here -->

## Credits
- Developed by Rogelio Lopez
- Weather data powered by your chosen API

## License
[MIT](LICENSE) 