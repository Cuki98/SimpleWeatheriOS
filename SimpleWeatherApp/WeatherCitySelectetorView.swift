//
//  WeatherCitySelectetorView.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 2/10/25.
//

import SwiftUI

struct WeatherCitySelectetorView: View {
    
    @State var cityName = ""
    
    var body: some View {
        
        NavigationStack{
            ZStack{
                Color.mBlack
                    .ignoresSafeArea() // Ensures the color fills the whole screen
                
                VStack{
                    ScrollView{
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        weatherCardButton()
                        
                    }.padding()
                }
            }.navigationTitle("Weather")
        }
    }
}

#Preview {
    WeatherCitySelectetorView()
}

struct weatherCardButton: View {
    var body: some View {
        HStack{
            VStack{
                Text("Las Vegas")
                    .font(.system(size: 28))
                Text("9:10PM")
            }
            Spacer()
            VStack{
                Text("49")
                    .font(.system(size: 48))
                HStack{
                    Text("H:58")
                    Text("L:69")
                }
            }
        }.padding()
            .frame(maxWidth: .infinity)
            .background(Color.mBlue, in: RoundedRectangle(cornerRadius: 16))
    }
}
