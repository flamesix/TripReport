//
//  TripReport.swift
//  TripReport
//
//  Created by Юрий Гриневич on 14.02.2022.
//

import Foundation

struct TripReport: Codable {
    var numberOfTripReport: Int
    var cityName: String
    var lrcNumber: String
    var lrcName: String
    var contractNumber: String
    
    static var archiveURL: URL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsURL.appendingPathComponent("tripReports").appendingPathExtension("plist")
        
        return archiveURL
    }
    
    static func saveToFile(tripReports: [TripReport]) {
        let encoder = PropertyListEncoder()
        do {
            let encodedBtrips = try encoder.encode(tripReports)
            try encodedBtrips.write(to: TripReport.archiveURL)
        } catch {
            print("Error encoding tripReports: \(error)")
        }
    }
    
    static func loadFromFile() -> [TripReport]? {
        guard let tripReportData = try? Data(contentsOf: TripReport.archiveURL) else {
            return nil
        }
        
        do {
            let decoder = PropertyListDecoder()
            let decodedTripReports = try decoder.decode([TripReport].self, from: tripReportData)
            
            return decodedTripReports
        } catch {
            print("Error decoding tripReports: \(error)")
            
            return nil
        }
    }
}
