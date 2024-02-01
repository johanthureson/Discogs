//
//  StaticFunctions.swift
//  Discogs
//
//  Created by Johan Thureson on 2024-02-01.
//

import Foundation

struct StaticFunctions {

    static func loadJson<T: Decodable>(_ type: T.Type, fileName: String) -> T? {
        
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(type, from: data)
                return jsonData
            } catch {
                print("error:\(error)")
            }
        } else {
            print()
        }
        return nil
    }
    
    static func isDayAfterTomorrowOrLater(unixTime: Int) -> Bool {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime))
        let calendar = Calendar.current

        // Get the date for the day after tomorrow
        guard let dayAfterTomorrow = calendar.date(byAdding: .day, value: 2, to: calendar.startOfDay(for: Date())) else {
            return false
        }

        // Compare the dates
        return calendar.compare(date, to: dayAfterTomorrow, toGranularity: .day) != .orderedAscending
    }
    
}
