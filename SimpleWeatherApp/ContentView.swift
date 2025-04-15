//
//  ContentView.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 11/8/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = WeatherViewModel()
  //  @State var weatherData: WeatherData
    // Create an instance of WeatherViewModel
    @State var cityName: String = "miami"
    
    var body: some View {
        ZStack() {
            backgroundLinearGradient()
            
            VStack {
                if let weatherData = viewModel.weatherData{
                    WeatherCard(weatherData: weatherData)
                } else{
                    ProgressView("Loading...")
                }
                Spacer()
                VStack{
                    Text("Weekly")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 25))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    HStack{
                        WeeklyWeather()
                    }.padding(.bottom)
                    Button{
                        viewModel.fetchWeather(cityName: cityName) // Fetch the weather data when the view appears

                        //print(weatherData.location.name)
                    }label: {
                        Text("Fetch Date")
                    }
                    
                    TextField("City Name", text: $cityName)
                        .background(Color(.systemGray6))
                        .padding(.all)
                        .onSubmit({
                            viewModel.fetchWeather(cityName: cityName)
                        })
                }
                .background(Gradient(colors: [.black.opacity(0.09)]), in: RoundedRectangle(cornerRadius: 20))
                .fixedSize()
                
                Spacer()
                Spacer()
                Spacer()
            }
        }.background(Color.black.gradient)
            .onAppear{
                print("hello")
                // Fetch the weather data when the view appears
                viewModel.fetchWeather(cityName: cityName)
                
             //    weatherData = viewModel.weatherData ?? MockWeatherData.sample
             //       print(weatherData.location.name)
   
            }
    }
}

#Preview {
    ContentView()
}

struct WeeklyWeather: View {
        @State var selectedButton: Int = 1
        let selectedColor: Gradient = Gradient(colors: [.indigo,.purple.opacity(0.7)])
        let unselectedColor: Gradient = Gradient(colors: [.black.opacity(0.09)])
    var body: some View {
        HStack {
            ForEach(1...5, id: \.self){
                buttonIndex in
                Button {
                    selectedButton = buttonIndex
                } label: {
                    VStack {
                        Text("19°C").foregroundColor(Color.white)
                        
                        Image(systemName: "cloud.sun")
                            .foregroundColor(Color.white)
                            .imageScale(.large)
                            .foregroundStyle(.black)
                        Text("Tue").foregroundColor(Color.white)
                    }
                }
                .padding()
                .background(selectedButton == buttonIndex ? selectedColor : unselectedColor, in: RoundedRectangle(cornerRadius: 30))
            }
        }
    }
}

struct backgroundLinearGradient: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.8),.black.opacity(0.9)]), startPoint: .leading, endPoint: .bottomTrailing)
            .ignoresSafeArea()
    }
}

struct WeatherCard: View {
     let weatherData: WeatherData
    let purpleGradient: Gradient = Gradient(colors: [.indigo,.purple.opacity(0.7)])

    var body: some View {
        VStack {
            Text(weatherData.location.name)
                .bold()
                .padding(.top)
            Image(systemName: "sun.max.fill")
                .resizable()
                .imageScale(.small)
                .foregroundStyle(.black)
                .frame(width:200, height: 200)
                .padding()
            Text(String(weatherData.current.temp_f))
                .bold()
                .font(.system(size: 40))
            
            HStack{
                Text("Max: 24")
                Text("Min: 24")
            }
            VStack{
                Text("Today").bold()
            }.padding(.bottom)
        }.frame(maxWidth: .infinity)
            .background(purpleGradient, in: RoundedRectangle(cornerRadius: 40))
            .padding(.horizontal)
    }
}
