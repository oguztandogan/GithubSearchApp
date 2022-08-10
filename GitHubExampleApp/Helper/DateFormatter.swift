//
//  DateFormatter.swift
//  GitHubExampleApp
//
//  Created by Oguz Tandogan on 2.08.2022.
//

import Foundation

/// Date Formatter
struct DateFormatterHelper {
    
    /// Returns the current date
    func getCurrentDate() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    /// Returns the one week ago date
    func getOneWeekAgoDate() -> String {
        guard let oneWeekAgoDate = Calendar.current.date(byAdding: .weekday, value: -7, to: Date()) else {
            return "Error"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: oneWeekAgoDate)
    }
    
    /// Returns the one month ago date
    func getOneMonthAgoDate() -> String {
        guard let oneMonthAgoDate = Calendar.current.date(byAdding: .month, value: -1, to: Date()) else {
            return "Error"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: oneMonthAgoDate)
    }
    
    /// Returns the one day ago date
    func getOneDayAgoDate() -> String {
        guard let oneDayAgoDate = Calendar.current.date(byAdding: .weekday, value: -1, to: Date()) else {
            return "Error"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: oneDayAgoDate)
    }
    
    /// Formats the date according to Details page
    func formatDate(dateText: String?) -> String {
        guard let dateText = dateText else {
            return "No data"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: dateText)
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let formattedDate = dateFormatter.string(from: date!)
        let currentDate = Date()
        let components = Calendar.current.dateComponents([.day], from: date!, to: currentDate)
        let dateString = components.day!.description + " days ago at " + formattedDate
            
        return dateString
        
    }
}
