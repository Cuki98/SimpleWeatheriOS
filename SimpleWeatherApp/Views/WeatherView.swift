import SwiftUI
import Charts

struct WeatherView: View {
    
    
    @StateObject var viewModel = WeatherViewModel()  // Create an instance of WeatherViewModel
    @State var cityName: String = "miami"

    var body: some View {
        ZStack {
            
            
            VStack {
                if let weatherData = viewModel.weatherData {
                    // Display weather data
                    Text(weatherData.location.name)
                        .font(.system(size: 34))
                        .bold()
                        .foregroundStyle(Color.white.gradient)
                    // circle card
                    CircleCardView(weatherData: weatherData)
                    
                    Spacer()
                    
                    TextField("Enter city name...", text: $cityName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12)
                                        .fill(Color(.systemGray6)))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(1), lineWidth: 1) // Adds a subtle border
                        )
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        .onSubmit {
                            viewModel.fetchWeather(cityName: cityName)
                        }
                    
              //      WeatherGraphView(weatherData: weatherData)
                    DayWeatherCard(weatherData: weatherData)
                    Spacer()

                } else if let errorMessage = viewModel.errorMessage {
                    // Display error message if something went wrong
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else {
                    // Show loading indicator if the data is being fetched
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                }
            }.padding()
            .onAppear {
                viewModel.fetchWeather(cityName: "Miami") // Fetch the weather data when the view appears
            }
        }.background(Image("backgroundImg")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea())
    }
    
}

#Preview {
    WeatherView()
}


struct HourlyWeatherCard: View {
    
    let weatherData: WeatherData
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15) {
                    if let forecastDay = weatherData.forecast.forecastday.first {
                        
                        ForEach(forecastDay.hour, id: \.self) { hour in
                            VStack(spacing: 20) {
                                Text(hour.hourFormated).foregroundColor(Color.white)
                                Image(systemName: "cloud.sun")
                                    .foregroundColor(Color.white)
                                    .imageScale(.large)
                                    .foregroundStyle(.black)
                                Text(String(hour.temp_f))
                                    .foregroundColor(Color.white)
                            }.padding()
                            
                        }
                    }
                }.fixedSize()
                
                
            }.padding()
                .background(Gradient(colors: [.purpleGradient,.redGradient]).opacity(0.6), in: RoundedRectangle(cornerRadius: 30))
        }
    }
}

struct DayWeatherCard: View {
    
    let weatherData: WeatherData
    
    var body: some View {
        ZStack {
                HStack(spacing: 15) {
                     let forecastDay = weatherData.forecast.forecastday
                        ForEach(forecastDay, id: \.self) { day in
                            VStack(spacing: 20) {
                                Text(day.weekday ?? "N/A").foregroundColor(Color.white)
                                Image(systemName: "cloud.sun")
                                    .foregroundColor(Color.white)
                                    .imageScale(.large)
                                    .foregroundStyle(.black)
                                
                                HStack{
                                    // hight temp for the day
                                    Text(String(format: "%.0f", weatherData.forecast.forecastday.first?.day.maxtemp_f ?? "N/A") + "°")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.white.gradient)
                                        .multilineTextAlignment(.center)
                                    // Low temp for the day
                                    Text(String(format: "%.0f", weatherData.forecast.forecastday.first?.day.mintemp_f ?? "N/A") + "°")
                                        .font(.system(size: 16))
                                        .foregroundStyle(Color.white.gradient)
                                        .multilineTextAlignment(.center) // Ensures text stays centered
                                }
                            }.padding()
                        }
                }.scaledToFill()
                .fixedSize()
                .padding()
                .background(Gradient(colors: [.purpleGradient,.redGradient]).opacity(0.6), in: RoundedRectangle(cornerRadius: 30))
       
        }
    }
}



struct CircleCardView: View {
    let weatherData: WeatherData

    var body: some View {
        ZStack{
            Circle()
                .foregroundStyle(Color.black.gradient.opacity(0.6))
                .frame(width: 250)
            Circle()
                .foregroundStyle(LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.purpleGradient), // Soft Purple
                        Color(.redGradient)  // Light Pink
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                )
                .frame(width: 220)
            VStack{
                //weather condition
                Text(weatherData.current.condition.text)
                    .fontWeight(.light)
                    .foregroundStyle(Color.white.gradient)
                    .multilineTextAlignment(.center) // Ensures text stays centered
                Text(" " + String(format: "%.0f", weatherData.current.temp_f.rounded(.toNearestOrEven)) + "°")
                    .font(.system(size: 60))
                    .foregroundStyle(Color.white.gradient)
                    .multilineTextAlignment(.center) // Ensures text stays centered
                HStack{
                    // hight temp for the day
                    Text("H:" + String(format: "%.0f", weatherData.forecast.forecastday.first?.day.maxtemp_f ?? "N/A") + "°")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.white.gradient)
                        .multilineTextAlignment(.center)
                    // Low temp for the day
                    Text("L:" + String(format: "%.0f", weatherData.forecast.forecastday.first?.day.mintemp_f ?? "N/A") + "°")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.white.gradient)
                        .multilineTextAlignment(.center) // Ensures text stays centered
                }
                
            }.frame(alignment: .center) // Ensures VStack stays centered
            
        }
    }
}

