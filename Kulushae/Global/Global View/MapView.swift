import SwiftUI
import MapboxMaps

import CoreLocation

class MapViewController: UIViewController {
    var fromVc = ""
    internal var mapView: MapView!
    var pointAnnotationManager: PointAnnotationManager!
    var location: CLLocationCoordinate2D
    weak var delegate: MapViewControllerDelegate?
    
    init(fromVC: String, location: CLLocationCoordinate2D) {
        self.fromVc = fromVC
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        print("** wk MapViewController location: \(location)")
        
        MapboxOptions.accessToken = Config.mapboxAPIkey
        
        //        let myResourceOptions = MapboxOptions(accessToken: Config.mapboxAPIkey)
        let cameraOptions = CameraOptions(center: location,zoom: 10)
        let myMapInitOptions = MapInitOptions( cameraOptions: cameraOptions)
        
        mapView = MapView(frame: view.bounds, mapInitOptions: myMapInitOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mapView)
        
        // Remove logo and attribution button
//        mapView.ornaments.logoView.isHidden = true
        mapView.ornaments.attributionButton.isHidden = true
        
        pointAnnotationManager = mapView.annotations.makePointAnnotationManager()
        
        if(self.fromVc != "details") {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
            mapView.addGestureRecognizer(tap)
            
        }
        
        updatePinPoint()
    }
    
    func updatePinPoint() {
        var pointAnnotation = PointAnnotation(coordinate: location)
        pointAnnotation.image = .init(image: UIImage(named: "imgPin2")!, name: "imgPin2")
        pointAnnotation.iconAnchor = .bottom
        
        
        pointAnnotationManager.annotations = [pointAnnotation]
        print("** wk map fromVC: \(self.fromVc)")
        
        animate(to: location, zoomLevel: 10)
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        let locationInView = sender.location(in: mapView)
        let tappedCoordinates = mapView.mapboxMap.coordinate(for: locationInView)
        var pointAnnotation = PointAnnotation(coordinate: tappedCoordinates)
        pointAnnotation.image = .init(image: UIImage(named: "imgPin2")!, name: "imgPin2")
        pointAnnotation.iconAnchor = .bottom
        
        pointAnnotationManager.annotations = [pointAnnotation]
//        animate(to: tappedCoordinates, zoomLevel: 10)
        self.delegate?.didTouchResult(tappedCoordinates: tappedCoordinates)
    }
    //    @objc func handleTap(_ sender: UITapGestureRecognizer) {
    //        let locationInView = sender.location(in: mapView)
    //        let tappedCoordinates = mapView.mapboxMap.coordinate(for: locationInView)
    //        var pointAnnotation = PointAnnotation(coordinate: tappedCoordinates)
    //        pointAnnotation.image = .init(image: UIImage(named: "red_pin")!, name: "red_pin")
    //        pointAnnotation.iconAnchor = .bottom
    //
    //        pointAnnotationManager.annotations = [pointAnnotation]
    //        animate(to: tappedCoordinates, zoomLevel: 10)
    //        let geocoder = CLGeocoder()
    //        geocoder.reverseGeocodeLocation(CLLocation(latitude: tappedCoordinates.latitude, longitude: tappedCoordinates.longitude)) { [weak self] placemarks, error in
    //            if let error = error {
    //                print("Geocoding error: \(error.localizedDescription)")
    //            } else if let city = placemarks?.first?.locality, let country = placemarks?.first?.country {
    //                self?.userLocationName = "\(city), \(abbreviatedCountry)"
    //            }
    //            manager.stopUpdatingLocation()
    //        }
    //    }
    
    func animate(to location: CLLocationCoordinate2D,
                 zoomLevel: CGFloat?,
                 completion: @escaping (UIViewAnimatingPosition) -> Void = { _ in }) {
        let newCamera = CameraOptions(center: location,
                                      padding: .zero,
                                      anchor: .zero,
                                      zoom: zoomLevel,
                                      bearing: 0.0,
                                      pitch: 0)
        
        //        self.mapView?.camera.ease(to: newCamera, duration: 0.0)
        
        self.mapView.camera.ease(to: newCamera, duration: 0.2, completion: completion)
        
    }
}

struct MapBoxMapView: UIViewControllerRepresentable {
    
    var fromVC = ""
    @Binding var selectedLocationCoordinate:  CLLocationCoordinate2D
    
    @Binding var selectedLoca: String
    var handler: ((MapViewController?)->())? = nil
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    
    func makeUIViewController(context: Context) -> MapViewController {
        print("** wk MapBoxMapView selectedLocationCoordinate: \(selectedLocationCoordinate)")
        var mapViewController = MapViewController(fromVC: fromVC, location: selectedLocationCoordinate)
        
        mapViewController.delegate = context.coordinator
        self.handler?(mapViewController)
        return mapViewController
    }
    
    func updateUIViewController(_ uiViewController: MapViewController, context: Context) {
    }
    
    class Coordinator: NSObject, MapViewControllerDelegate {
        var parent: MapBoxMapView
        var pointAnnotationManager: PointAnnotationManager!
        
        init(_ parent: MapBoxMapView) {
            self.parent = parent
        }
        
        func didTouchResult(tappedCoordinates: CLLocationCoordinate2D) {
            self.parent.selectedLocationCoordinate = tappedCoordinates
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(CLLocation(latitude: tappedCoordinates.latitude, longitude: tappedCoordinates.longitude)) { [weak self] placemarks, error in
                if let error = error {
                    print("Geocoding error: \(error.localizedDescription)")
                } else if let city = placemarks?.first?.name {
                    self?.parent.selectedLoca  = "\(city)"
                }
            }
            
        }
    }
}
protocol MapViewControllerDelegate: AnyObject {
    func didTouchResult(tappedCoordinates: CLLocationCoordinate2D)
    
}
