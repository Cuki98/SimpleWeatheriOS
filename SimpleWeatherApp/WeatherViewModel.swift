//
//  WeatherViewModel.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 12/7/24.
//

import Foundation
import Alamofire
import Combine

class WeatherViewModel: ObservableObject {
  //  var cityName: String = "Miami"
    @Published var weatherData: WeatherData?
    @Published var errorMessage: String?

    func fetchWeather(cityName: String) {
     //   let url = "https://api.weatherapi.com/v1/current.json?key=24626f86041d4f87a9281543250302&q=\(cityName)&aqi=no"
        let api: String = "24626f86041d4f87a9281543250302"
        let url = "https://api.weatherapi.com/v1/forecast.json?key=\(api)&q=\(cityName)&days=3&aqi=no&alerts=no"
        AF.request(url)
            .validate()
            .responseDecodable(of: WeatherData.self) { response in
                switch response.result {
                case .success(let data):
                    // On success, update the weatherData property
                    DispatchQueue.main.async {
                        self.weatherData = data
                    }
                case .failure(let error):
                    // On failure, set the error message
                    DispatchQueue.main.async {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
    }
}
