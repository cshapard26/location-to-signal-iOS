import UIKit
import CoreLocation

class ViewController: UIViewController {
    let locationService = LocationService()
    let csvService = CSVService()
    var isMeasuringAutomatically = false
    var timer: Timer?

    @IBOutlet weak var manualButton: UIButton!
    @IBOutlet weak var automaticButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        manualButton.addTarget(self, action: #selector(takeManualMeasurement), for: .touchUpInside)
        automaticButton.addTarget(self, action: #selector(toggleAutomaticMeasurement), for: .touchUpInside)
    }

    @objc func takeManualMeasurement() {
        locationService.requestLocation { (latitude, longitude, signalStrength) in
            let data = MeasurementData(timestamp: Date().description, latitude: latitude, longitude: longitude, signalStrength: signalStrength)
            self.csvService.writeToCSV(data: data)
        }
    }

    @objc func toggleAutomaticMeasurement() {
        if isMeasuringAutomatically {
            timer?.invalidate()
            isMeasuringAutomatically = false
            automaticButton.setTitle("Start Automatic Measurements", for: .normal)
        } else {
            let interval = 180.0 // Change based on user input
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                self.takeManualMeasurement()
            }
            isMeasuringAutomatically = true
            automaticButton.setTitle("Stop Automatic Measurements", for: .normal)
        }
    }
}
