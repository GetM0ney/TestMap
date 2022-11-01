//
//  DatailUserViewController.swift
//  TestAppMap
//
//  Created by Lishanenka, Uladzimir on 30.10.22.
//

import UIKit
import MapKit

class DetailUserViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  
  let locationManager = CLLocationManager()
  var locationsViewModel: DetailsViewModel?
  
  var timer: Timer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.mapView.delegate = self
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    timer?.invalidate()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    askForLocationIfNeeded()
    addVehicleAnnotations()
  }
  
  private func setupManager() {
    locationManager.delegate = self
    locationManager.desiredAccuracy = .greatestFiniteMagnitude
  }
  
  func startTimer() {
    DispatchQueue.main.async {
      self.timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true, block: { timer in
        self.locationsViewModel?.getLocationData { error in
          if let error = error {
            self.showError(error: error)
          } else {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.addVehicleAnnotations()
          }
        }
      })
    }
  }
  
  private func askForLocationIfNeeded() {
    if CLLocationManager.locationServicesEnabled() {
      setupManager()
      checkAutorizationStatus()
    } else {
      showLocationAlert(title: "Location is not available", message: "Enable location?", urlString: "App-Prefs:root=LOCATION_SERVICES", alertActionTitle: "Settings")
    }
  }
  
  private func addVehicleAnnotations() {
    guard let vehicles = locationsViewModel?.vehiclesWithLocation else { return }
    mapView.addAnnotations(vehicles)
  }
  
  private func showLocationAlert(title: String, message: String?, urlString: String?, alertActionTitle: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let settingAction = UIAlertAction(title: alertActionTitle, style: .default) { (alert) in
      guard let urlString = urlString, let url = URL(string: urlString) else { return }
      UIApplication.shared.open(url)
    }
    let cancelAction = UIAlertAction(title: "cancel", style: .cancel)
    alert.addAction(settingAction)
    alert.addAction(cancelAction)
    
    present(alert, animated: true)
  }
  
  private func checkAutorizationStatus() {
    switch locationManager.authorizationStatus {
      case .authorizedAlways:
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
      case .authorizedWhenInUse:
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
      case .denied:
        showLocationAlert(title: "location usage denied", message: "Enable location", urlString: UIApplication.openSettingsURLString, alertActionTitle: "Settings")
      case .restricted:
        break
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      default:
        fatalError()
    }
  }
}

extension DetailUserViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    if let location = locations.last?.coordinate {
      let region = MKCoordinateRegion(center: location, latitudinalMeters: 5000, longitudinalMeters: 5000)
      mapView.setRegion(region, animated: true)
    }
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkAutorizationStatus()
  }
}

extension DetailUserViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    guard let annotation = annotation as? VehicleWithLocation else { return nil }
    var markerView :MKMarkerAnnotationView
    let viewID = "markerView"
    if let view = mapView.dequeueReusableAnnotationView(withIdentifier: viewID) as? MKMarkerAnnotationView {
      view.annotation = annotation
      markerView = view
    } else {
      markerView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: viewID)
      markerView.canShowCallout = true
      markerView.calloutOffset = CGPoint(x: 0, y: 0)
      markerView.rightCalloutAccessoryView = UIButton(type: .infoDark)
    }
    return markerView
  }
  
  func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
    guard let coordinate = locationManager.location?.coordinate else { return }
    
    mapView.removeOverlays(mapView.overlays)
    
    let vehicle = view.annotation as! VehicleWithLocation
    let startpoint = MKPlacemark(coordinate: coordinate)
    let endpoint = MKPlacemark(coordinate: vehicle.coordinate)
    
    let request = MKDirections.Request()
    request.source = MKMapItem(placemark: startpoint)
    request.destination = MKMapItem(placemark: endpoint)
    request.transportType = .walking
    
    let direction =  MKDirections(request: request)
    direction.calculate { responce, error in
      guard let responce = responce else { return }
      responce.routes.forEach { route in
        mapView.addOverlay(route.polyline)
      }
    }
  }
  
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    let render = MKPolylineRenderer(overlay: overlay)
    render.strokeColor = .red
    render.lineWidth = 5
    return render
  }
  
  
  func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
    guard let controller = UIStoryboard.init(name: "VehicleDescriptionViewController",
                                             bundle: Bundle.main).instantiateViewController(withIdentifier: "VehicleDescriptionViewController") as? VehicleDescriptionViewController else { return }
    let annotation = view.annotation as! VehicleWithLocation
    controller.vehicleModel = Vehicle(vehicleid: annotation.vehicleid,
                                      make: annotation.make,
                                      model: annotation.model,
                                      year: annotation.year,
                                      color: annotation.color,
                                      vin: annotation.vin,
                                      foto: annotation.foto)
    present(controller, animated: true)
  }
}
