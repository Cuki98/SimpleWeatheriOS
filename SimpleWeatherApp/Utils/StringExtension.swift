//
//  StringExtension.swift
//  SimpleWeatherApp
//
//  Created by Rogelio Lopez on 2/10/25.
//

import Foundation

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst().lowercased()
    }
    
    
    func formattedDate() -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        inputFormatter.locale = Locale(identifier: "en_US")

        guard let date = inputFormatter.date(from: self) else {
            return "Invalid Date"
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MMMM d, EEEE" // Example: "December 15, Sunday"
        return outputFormatter.string(from: date)
    }
}

func getFormattedToday() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM d, EEEE" // Example: "December 15, Sunday"
    dateFormatter.locale = Locale(identifier: "en_US")
    
    return dateFormatter.string(from: Date())
}
