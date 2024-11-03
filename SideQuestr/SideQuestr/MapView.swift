import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @State var location: MapCameraPosition = .userLocation(fallback: .automatic)
    @ObservedObject private var locationManager = LocationManager.shared
    @State private var showingNotice = false
    @State private var message: String = ""
    @State private var userInput: String = ""
    @State private var level: Int32 = Int32(UserDefaults.standard.integer(forKey: "level")) // Load level from UserDefaults
    @State private var exp: Int32 = Int32(UserDefaults.standard.integer(forKey: "exp"))   // Load exp from UserDefaults
    @StateObject var questModel = QuestModel()

    var body: some View {
        ZStack {
            MapViewWrapper(locations: $locationManager.locations)
                .edgesIgnoringSafeArea(.top)

            if showingNotice {
                FloatingNotice(showingNotice: $showingNotice)
                    .transition(.scale)
            }
            VStack {
                Spacer()
                CircularXPBar(level: level, curr_exp: exp)
                    .frame(width: 100, height: 100)
                    .position(x:80, y: 45)
            }
        }
        .onChange(of: level) { newValue in
            saveLevel(level: newValue)
        }
        .onChange(of: exp) { newValue in
            saveExp(exp: newValue)
        }
    }

    private func saveLevel(level: Int32) {
        UserDefaults.standard.set(level, forKey: "level")
    }

    private func saveExp(exp: Int32) {
        UserDefaults.standard.set(exp, forKey: "exp")
    }
}

struct MapViewWrapper: UIViewRepresentable {
    @Binding var locations: [CLLocation]
    let circleRadius: CLLocationDistance = 1000

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true

        let button = MKUserTrackingButton(mapView: mapView)
        button.translatesAutoresizingMaskIntoConstraints = false
        mapView.addSubview(button)
        button.backgroundColor = UIColor.white
        mapView.userTrackingMode = .follow

        NSLayoutConstraint.activate([
            button.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10),
            button.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10)
        ])

        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        if !context.coordinator.hasOverlayBeenUpdated(for: locations) {
            context.coordinator.updateOverlay(for: uiView, with: locations)
        }
    }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewWrapper
    private var lastLocations: [CLLocation] = []
    weak var mapView: MKMapView?

    init(_ parent: MapViewWrapper) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let color = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.4)
        let renderer = MKPolygonRenderer(overlay: overlay)
        renderer.fillColor = color
        return renderer
    }

    public func hasOverlayBeenUpdated(for newLocations: [CLLocation]) -> Bool {
        let isUpdated = newLocations != lastLocations
        lastLocations = newLocations
        return isUpdated
    }
    
    let WORLD_COORDINATES = [
        CLLocationCoordinate2D(latitude: 90, longitude: 0),
        CLLocationCoordinate2D(latitude: 90, longitude: 180),
        CLLocationCoordinate2D(latitude:-90, longitude: 180),
        CLLocationCoordinate2D(latitude:-90, longitude: 0),
        CLLocationCoordinate2D(latitude:-90, longitude:-180),
        CLLocationCoordinate2D(latitude: 90, longitude:-180)
    ]
    
    func updateOverlay(for mapView: MKMapView, with locations: [CLLocation]) {
        mapView.removeOverlays(mapView.overlays)

        guard !locations.isEmpty else { return }

        let fullRadius = CLLocationDistance(exactly: MKMapRect.world.size.height) ?? 0
        
        var circles: [MKPolygon] = []
        for location in locations {
            let circleCoordinates = makeCircleCoordinates(location.coordinate, radius: 400.0)
            let circle = MKPolygon(coordinates: circleCoordinates, count: circleCoordinates.count, interiorPolygons: nil)
            circles.append(circle)
        }
        
        var dark = MKPolygon(coordinates: WORLD_COORDINATES, count: WORLD_COORDINATES.count, interiorPolygons: circles)
        mapView.addOverlay(dark)

    }
    
    func makeCircleCoordinates(_ coordinate: CLLocationCoordinate2D, radius: Double, tolerance: Double = 3.0) -> [CLLocationCoordinate2D] {
        let latRadian = coordinate.latitude * .pi / 180
        let lngRadian = coordinate.longitude * .pi / 180
        let distance = (radius / 1000) / 6371 // kms
        return stride(from: 0.0, to: 360.0, by: tolerance).map {
            let bearing = $0 * .pi / 180

            let lat2 = asin(sin(latRadian) * cos(distance) + cos(latRadian) * sin(distance) * cos(bearing))
            var lon2 = lngRadian + atan2(sin(bearing) * sin(distance) * cos(latRadian),cos(distance) - sin(latRadian) * sin(lat2))
            lon2 = fmod(lon2 + 3 * .pi, 2 * .pi) - .pi  // normalise to -180..+180º
            return CLLocationCoordinate2D(latitude: lat2 * (180.0 / .pi), longitude: lon2 * (180.0 / .pi))

        }
    }
}

#Preview {
    MapView()
}
