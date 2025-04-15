//
//  MinimalisticWeatherView.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 2/6/25.
//

import SwiftUI

let backgroundGradient = LinearGradient(
    colors: [.mBlack, .mBlack.opacity(0.94)],
    startPoint: .top, endPoint: .bottom)

struct MinimalisticWeatherView: View {
    
    @StateObject var viewModel = WeatherViewModel()  // Create an instance of WeatherViewModel
    @State var cityName: String = "Las Vegas"
    @State var selectedDay: Int = 0
    @State var navigateToAnotherView: Bool = false

    
    var body: some View {
        NavigationStack {
            ZStack {
                backgroundGradient

                
                // Hidden NavigationLink that triggers when navigateToAnotherView becomes true
                NavigationLink(
                    destination: WeatherCitySelectetorView(), // Replace with your destination view
                    isActive: $navigateToAnotherView
                ) {
                    EmptyView()
                }
                
                if let weatherData = viewModel.weatherData{
                    VStack {
                        HStack {
                            CityAndDateView(cityName: $cityName)
                            Spacer()
                            AddCityButtonView(navigateToAnotherView: $navigateToAnotherView)
                        }.padding(.top)
                            .padding(.top)
                            .padding(.top)
                        
                        CurrentWeatherInfoView(weatherData: weatherData)
                        PropertiesWeatherCardView(weatherData: weatherData)
                        DaySelectorView(weatherData: weatherData, selectedDay: $selectedDay)
                        MinimalisticHourlyWeatherView(weatherData: weatherData, selectedDay: $selectedDay)
                        
                        Spacer()
                    }
                } else {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .mWhite))
                        .foregroundStyle(Color.mWhite)
                        .padding()
                }
            }.ignoresSafeArea()
                .onAppear(perform: {
                    viewModel.fetchWeather(cityName: cityName)
                })
        }
    }
}

#Preview {
    MinimalisticWeatherView()
}

import SwiftUI

struct PropertiesWeatherCardView: View {
    let weatherData: WeatherData
    
    var body: some View {
        let propertyData = weatherData.current
        let rainChance = weatherData.forecast.forecastday.first?.day.daily_chance_of_rain ?? 69

        HStack {
            WeatherPropertyView(icon: "wind", value: String(format: "%.0f m/s", propertyData.wind_mph), label: "Wind")
            WeatherPropertyView(icon: "drop.fill", value: "\(propertyData.humidity)%", label: "Humidity")
            WeatherPropertyView(icon: "cloud.rain.fill", value: "\(rainChance)%", label: "Rain")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.mBlue, in: RoundedRectangle(cornerRadius: 16))
        .padding()
    }
}

struct WeatherPropertyView: View {
    let icon: String
    let value: String
    let label: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundStyle(Color.gray)
            Text(value)
                .bold()
                .font(.system(size: 20))
                .foregroundStyle(Color.mWhite)
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(Color.gray)
        }
        .frame(maxWidth: .infinity)
    }
}


struct MinimalisticHourlyWeatherView: View {
    
    let weatherData: WeatherData
    @Binding var selectedDay: Int
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15) {
                    
                    // Use forecastDay safely
                    if selectedDay < weatherData.forecast.forecastday.count {
                        let forecastDay = weatherData.forecast.forecastday[selectedDay]
                        
                        ForEach(forecastDay.hour.indices, id: \.self) { index in
                            let hour = forecastDay.hour[index]
                            VStack(spacing: 20) {
                                Text(hour.hourFormated).foregroundColor(Color.white)
                                WeatherIconView(weatherData: weatherData, selectedDay: $selectedDay, hour: index)
//                                Image(systemName: hour.condition.icon)
//                                    .foregroundColor(Color.white)
//                                    .imageScale(.large)
//                                    .foregroundStyle(.black)
                                Text(String(hour.temp_f))
                                    .foregroundColor(Color.white)
                            }.padding()
                            
                        }
                    }
                }.fixedSize()
                
                
            }.padding()
             .background(Color.mBlue, in: RoundedRectangle(cornerRadius: 16))
             .padding()

        }
    }
}

struct DaySelectorView: View {
    
    let weatherData: WeatherData
    @Binding var selectedDay: Int
    
    var body: some View {
        let DayOfWeek = weatherData.forecast.forecastday

        HStack (spacing: 20){
            ForEach(DayOfWeek.indices, id: \.self) { index in
                let day = DayOfWeek[index]
                    Button(action: {
                        selectedDay = index
                        
                    }, label: {
                        VStack{
                            let displayText = (index == 0) ? "Today" : (day.weekday ?? "Nil")

                            if selectedDay == index{
                                Text(displayText)
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.mWhite)
                                Circle()
                                    .frame(width: 4, height: 4)
                                    .foregroundStyle(Color.mWhite)
                            } else {
                                Text(displayText)
                                    .font(.system(size: 20))
                                    .foregroundStyle(Color.gray)
                            }
                        }
                    })
                }.onAppear(perform: {
                    if !DayOfWeek.isEmpty{
                        selectedDay = 0
                    }
                })
            Spacer()
        }.frame(maxWidth: .infinity)
            .padding()
    }
}



struct WeatherIconView: View {
    let weatherData: WeatherData
    @Binding var selectedDay: Int
    let hour: Int
    let imageUrl = "https:"

    var body: some View {
        
        let weatherIcon = weatherData.forecast.forecastday[selectedDay].hour[hour].condition.icon
            
        AsyncImage(url: URL(string: imageUrl + weatherIcon)) { phase in
            switch phase {
            case .empty:
                ProgressView() // Shows a loading indicator
            case .success(let image):
                image.resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40) // Adjust size as needed
            case .failure:
                Image(systemName: "photo") // Fallback image if loading fails
                    .foregroundColor(.gray)
                    .frame(width: 40, height: 40)
            @unknown default:
                EmptyView()
            }
        }
    }
}

struct CityAndDateView: View {
    @Binding var cityName: String
    let today = getFormattedToday()
    var body: some View {
        VStack(alignment: .leading){
            Text(cityName.capitalizingFirstLetter())
                .bold()
                .font(.system(size: 30))
                .foregroundStyle(Color.mWhite)
            Text(today)
                .foregroundStyle(Color.gray)

        }
        .padding(.leading)
    }
    


}

struct AddCityButtonView: View {
    
    @Binding var navigateToAnotherView: Bool

    var body: some View {
        Button(action: {
            navigateToAnotherView = true
        }, label: {
            ZStack {
                Rectangle()
                    .frame(width: 50, height: 50)
                    .foregroundStyle(Color.mBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 20));
                Image(systemName: "plus.square")
                    .foregroundStyle(Color.gray)
            }.padding(.horizontal)
        })
    }
}

struct CurrentWeatherInfoView: View {
    let weatherData: WeatherData
    var body: some View {
        HStack{
            VStack{
                Text(" " + String(format: "%.0f", weatherData.current.temp_f) + "°")
                    .bold()
                    .font(.system(size: 100))
                    .foregroundStyle(Color.mWhite)
                Text(weatherData.current.condition.text)
                    .foregroundStyle(Color.gray)
            }
            Spacer()
         //   weatherData.current.
            Image(systemName: "cloud.moon.bolt.fill")
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.gray)
                .frame(width: 150,height: 150)
            
        }.padding(.horizontal)
    }
}
