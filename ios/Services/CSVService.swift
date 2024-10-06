import Foundation

class CSVService {
    static let shared = CSVService()

    func createCSVFile() -> URL? {
        let fileManager = FileManager.default
        let fileName = "location-to-signal-measurements.csv"
        let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first

        if let fileURL = documentDirectory?.appendingPathComponent(fileName) {
            if !fileManager.fileExists(atPath: fileURL.path) {
                let headers = "Timestamp, Latitude, Longitude, Signal Strength\n"
                do {
                    try headers.write(to: fileURL, atomically: true, encoding: .utf8)
                } catch {
                    print("Error creating file")
                }
            }
            return fileURL
        }
        return nil
    }

    func writeToCSV(data: MeasurementData) {
        guard let fileURL = createCSVFile() else { return }

        let newRow = "\(data.timestamp), \(data.latitude), \(data.longitude), \(data.signalStrength)\n"
        do {
            let fileHandle = try FileHandle(forWritingTo: fileURL)
            fileHandle.seekToEndOfFile()
            if let rowData = newRow.data(using: .utf8) {
                fileHandle.write(rowData)
            }
            fileHandle.closeFile()
        } catch {
            print("Error writing to CSV")
        }
    }
}
