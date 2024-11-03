import CoreLocation
import CoreData
import UIKit
import Combine
import Foundation

public class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private let manager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()

    @Published var isAuthorized: Bool = false
    @Published var locations: [CLLocation] = []

    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        checkAuthorizationStatus()
        startBackgroundTracking()
        
        LocationStore.shared.$locations
            .assign(to: \.locations, on: self)
            .store(in: &cancellables)
    }

    private var minLocationDistance: Double = 100.0 // in metres
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        let savedLocations = LocationStore.shared.fetchAllLocations()
        let lastSavedLocation = savedLocations.last
         
        if let lastLocation = lastSavedLocation, newLocation.distance(from: lastLocation) < minLocationDistance {
            return
        }
        
        LocationStore.shared.saveLocation(newLocation)
    }
    
    public func startBackgroundTracking() {
        if isAuthorized {
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
            manager.startUpdatingLocation()
        } else {
            print("Location services are not authorized.")
        }
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
        startBackgroundTracking()
    }

    public func checkAuthorizationStatus() {
        isAuthorized = manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse
    }
}

class LocationStore : ObservableObject {
    static let shared = LocationStore()
    private let context = PersistenceController.shared.container.viewContext

    @Published var locations: [CLLocation] = []

    init() {
         locations = fetchAllLocations()
     }
    
    func saveLocation(_ location: CLLocation) {
        let newLocation = Location(context: context)
        newLocation.latitude = location.coordinate.latitude
        newLocation.longitude = location.coordinate.longitude
        newLocation.timestamp = location.timestamp

        do {
            try context.save()
            locations = fetchAllLocations()
        } catch {
            print("Failed to save location: \(error.localizedDescription)")
        }
    }

    func fetchAllLocations() -> [CLLocation] {
        let fetchRequest: NSFetchRequest<Location> = Location.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]

        do {
            let savedLocations = try context.fetch(fetchRequest)
            return savedLocations.compactMap { savedLocation in
                guard let timestamp = savedLocation.timestamp else { return nil }
                let coordinate = CLLocationCoordinate2D(latitude: savedLocation.latitude, longitude: savedLocation.longitude)
                return CLLocation(coordinate: coordinate, altitude: 0, horizontalAccuracy: 0, verticalAccuracy: 0, timestamp: timestamp)
            }
        } catch {
            print("Failed to fetch locations: \(error.localizedDescription)")
            return []
        }
    }
}
