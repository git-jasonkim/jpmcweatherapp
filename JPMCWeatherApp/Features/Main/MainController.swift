//
//  MainController.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/7/23.
//

import UIKit
import CoreLocation

class MainController: UIViewController {
    
    internal let vm: MainControllerViewModel
    private let geolocationService = GeolocationService()

    init(vm: MainControllerViewModel = MainControllerViewModel()) {
        self.vm = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVM()
        setupNavigation()
        setupSubviews()
        setupGeolocationService()
        setupGesturesToDismissKeyboard()
    }
    
    //targets
    @objc private func handleDismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func handleSearch() {
        guard let location = searchTextField.text?.trimmingCharacters(in: .whitespaces) else { return }
        Task {
            await vm.searchWeather(for: location)
        }
    }
    
    @objc private func handleUserCurrentLocation() {
        geolocationService.fetchLocation()
    }
    
    //subviews
    lazy private(set) var searchTextField: UITextField = {
        let tf = UITextField()
        tf.attributedPlaceholder = NSAttributedString(string:"Enter a US City", attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        tf.tintColor = .black
        tf.textColor = .black
        tf.layer.borderWidth = 2
        tf.layer.borderColor = UIColor.blue.cgColor
        tf.layer.masksToBounds = true
        tf.layer.cornerRadius = 10
        tf.clearButtonMode = .always
        tf.setLeftPaddingPoints(16)
        tf.delegate = self
        return tf
    }()
    
    lazy private var searchButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal)
        buttonConfig.image = image
        let button = UIButton(configuration: buttonConfig, primaryAction: nil)
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
        return button
    }()
    
    lazy private var userCurrentLocationButton: UIButton = {
        var buttonConfig = UIButton.Configuration.plain()
        let image = UIImage(systemName: "location.fill")?.withRenderingMode(.alwaysOriginal)
        buttonConfig.image = image
        let button = UIButton(configuration: buttonConfig, primaryAction: nil)
        button.contentMode = .scaleAspectFit
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handleUserCurrentLocation), for: .touchUpInside)
        return button
    }()
    
    lazy private(set) var statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Status: Need a location for weather information."
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var weatherController: WeatherController = {
        let cv = WeatherController()
        return cv
    }()

    //setups
    /// Must define MainControllerViewModel handleState
    ///
    /// 1. Create WeatherViewModel using retrieved Weather data to pass to WeatherController vm property
    /// 2. Handle different view states
    private func setupVM() {
        vm.handleState = { [weak self] state in
            guard let self = self else { return }
            let statusText = {
                switch state {
                case .loading:
                    return "loading"
                case .success(let weatherData):
                    self.searchTextField.text = weatherData.name
                    let vm = WeatherViewModel(weatherData: weatherData)
                    self.weatherController.vm = vm
                    return "success"
                case .failure(let error):
                    return error
                default:
                    return ""
                }
            }()
            statusLabel.text = "Status: \(statusText)"
        }
        
        guard let lastSearchedLocation = UserDefaults.standard.string(forKey: UserDefaults.Key.lastSearchedLocation) else {
            return }
        searchTextField.text = lastSearchedLocation
        handleSearch()

    }
    
    private func setupNavigation() {
        self.title = "JPMC Weather App"
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    private func setupSubviews() {
        view.backgroundColor = .white
        
        view.addSubview(userCurrentLocationButton)
        userCurrentLocationButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 32, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 16, width: 40, height: 40)
        
        view.addSubview(searchButton)
        searchButton.anchor(centerX: nil, centerY: userCurrentLocationButton.centerYAnchor, top: nil, leading: nil, bottom: nil, trailing: userCurrentLocationButton.leadingAnchor, paddingTop: 0, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 8, width: 40, height: 40)

        view.addSubview(searchTextField)
        searchTextField.anchor(centerX: nil, centerY: userCurrentLocationButton.centerYAnchor, top: nil, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: searchButton.leadingAnchor, paddingTop: 0, paddingLeading: 16, paddingBottom: 0, paddingTrailing: 8, width: 0, height: 48)

        view.addSubview(statusLabel)
        statusLabel.anchor(top: searchTextField.bottomAnchor, leading: searchTextField.leadingAnchor, bottom: nil, trailing: userCurrentLocationButton.trailingAnchor, paddingTop: 8, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 0, width: 0, height: 0)
        
        if let weatherView = weatherController.view {
            view.addSubview(weatherView)
            addChild(weatherController)
            weatherView.anchor(top: statusLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTop: 24, paddingLeading: 0, paddingBottom: 0, paddingTrailing: 0, width: 0, height: 0)
        }
    }
    
    private func setupGeolocationService() {
        geolocationService.delegate = self
    }
    
    private func setupGesturesToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        let swipGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleDismissKeyboard))
        swipGesture.direction = .down
        view.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(swipGesture)
    }
    
}

extension MainController: GeolocationServiceDelegate {
    func didUpdateLocation(coordinate: CLLocationCoordinate2D?, error: Error?) {
        guard let coordinate = coordinate else { return }
        Task {
            await vm.searchWeather(for: coordinate)
        }
    }
}

extension MainController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        handleSearch()
        return true
    }
}
