//
//  Weather.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 12/7/24.
//

import Foundation
import Alamofire

struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather
    let forecast: Forecast
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let humidity: Int
    let precip_mm: Double
    let feelslike_c: Double
    let feelslike_f: Double
    let uv: Double
}

struct Condition: Codable, Hashable {
    let text: String
    let icon: String
    let code: Int
    
    // Conforming to Hashable by implementing hash(into:)
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(icon)
        hasher.combine(code)
    }
}

struct Forecast: Codable, Hashable{
    let forecastday: [ForecastDay]
}

struct ForecastDay: Codable, Hashable {
    let date: String
    let day: DayWeather
    let astro: Astro
    let hour: [HourlyWeather]
    /// Computed property to get the day of the week
    var weekday: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        if let dateObj = dateFormatter.date(from: date) {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"  // Full day name
            return weekdayFormatter.string(from: dateObj)
        }
        
        return nil
    }
}

struct DayWeather: Codable, Hashable {
    let maxtemp_c: Double
    let maxtemp_f: Double
    let mintemp_c: Double
    let mintemp_f: Double
    let avgtemp_c: Double
    let avgtemp_f: Double
    let maxwind_mph: Double
    let maxwind_kph: Double
    let totalprecip_mm: Double
    let condition: Condition
    let daily_chance_of_rain: Int
    let uv: Double
}

struct Astro: Codable, Hashable {
    let sunrise: String
    let sunset: String
    let moonrise: String
    let moonset: String
    let moon_phase: String
    let moon_illumination: Int
}

struct HourlyWeather: Codable, Hashable {
    let time: String
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let humidity: Int
    let precip_mm: Double
    let uv: Double
    
    var hourFormated: String {
            convertToHour(time)
        }
        
        private func convertToHour(_ time: String) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"  // Input format
            dateFormatter.timeZone = TimeZone.current
            
            if let date = dateFormatter.date(from: time) {
                let hourFormatter = DateFormatter()
                hourFormatter.dateFormat = "h a"  // Use "HH" for 24-hour format
                return hourFormatter.string(from: date)
            }
            
            return "Invalid Time"
        }
    
    // Conforming to Hashable by implementing hash(into:)
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
        hasher.combine(temp_c)
        hasher.combine(temp_f)
        hasher.combine(is_day)
        hasher.combine(condition)
        hasher.combine(wind_mph)
        hasher.combine(wind_kph)
        hasher.combine(humidity)
        hasher.combine(precip_mm)
        hasher.combine(uv)
    }
}


struct MockWeatherData {
    static let sample = WeatherData(
        location: Location(
            name: "Miami",
            region: "Florida",
            country: "United States of America",
            lat: 25.7739,
            lon: -80.1939,
            tz_id: "America/New_York",
            localtime: "2025-02-04 20:30"
        ),
        current: CurrentWeather(
            temp_c: 23.3,
            temp_f: 73.9,
            is_day: 0,
            condition: Condition(
                text: "Clear",
                icon: "//cdn.weatherapi.com/weather/64x64/night/113.png",
                code: 1000
            ),
            wind_mph: 10.5,
            wind_kph: 16.9,
            humidity: 76,
            precip_mm: 0.0,
            feelslike_c: 25.7,
            feelslike_f: 78.2,
            uv: 0.0
        ),
        forecast: Forecast(
            forecastday: [
                ForecastDay(
                    date: "2025-02-04",
                    day: DayWeather(
                        maxtemp_c: 25.0,
                        maxtemp_f: 77.0,
                        mintemp_c: 21.2,
                        mintemp_f: 70.2,
                        avgtemp_c: 22.6,
                        avgtemp_f: 72.7,
                        maxwind_mph: 11.4,
                        maxwind_kph: 18.4,
                        totalprecip_mm: 0.0,
                        condition: Condition(
                            text: "Partly Cloudy",
                            icon: "//cdn.weatherapi.com/weather/64x64/day/116.png",
                            code: 1003
                        ),
                        daily_chance_of_rain: 1,
                        uv: 1.3
                    ),
                    astro: Astro(
                        sunrise: "07:03 AM",
                        sunset: "06:07 PM",
                        moonrise: "11:03 AM",
                        moonset: "No moonset",
                        moon_phase: "Waxing Crescent",
                        moon_illumination: 35
                    ),
                    hour: [
                        HourlyWeather(
                            time: "2025-02-04 00:00",
                            temp_c: 21.5,
                            temp_f: 70.7,
                            is_day: 0,
                            condition: Condition(
                                text: "Fog",
                                icon: "//cdn.weatherapi.com/weather/64x64/night/248.png",
                                code: 1135
                            ),
                            wind_mph: 9.8,
                            wind_kph: 15.8,
                            humidity: 98,
                            precip_mm: 0.0,
                            uv: 0.0
                        )
                    ]
                )
            ]
        )
    )
}



/*
struct WeatherData: Codable {
    let location: Location
    let current: CurrentWeather
}

struct Location: Codable {
    let name: String
    let region: String
    let country: String
    let lat: Double
    let lon: Double
    let tz_id: String
    let localtime: String
}

struct CurrentWeather: Codable {
    let temp_c: Double
    let temp_f: Double
    let is_day: Int
    let condition: Condition
    let wind_mph: Double
    let wind_kph: Double
    let humidity: Int
    let precip_mm: Double
}

struct Condition: Codable {
    let text: String
    let icon: String
    let code: Int
}

struct MockWeatherData {
    static let sample = WeatherData(
        location: Location(
            name: "Miami",
            region: "Florida",
            country: "USA",
            lat: 25.7617,
            lon: -80.1918,
            tz_id: "America/New_York",
            localtime: "2025-02-02 12:00"
        ),
        current: CurrentWeather(
            temp_c: 30.5,
            temp_f: 86.9,
            is_day: 1,
            condition: Condition(
                text: "Sunny",
                icon: "//cdn.weatherapi.com/weather/64x64/day/113.png",
                code: 1000
            ),
            wind_mph: 5.0,
            wind_kph: 8.0,
            humidity: 70,
            precip_mm: 0.0
        )
    )
}
*/
