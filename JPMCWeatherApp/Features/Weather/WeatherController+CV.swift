//
//  WeatherController+CV.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

class WeatherController: UICollectionViewController {
    
    public var vm: WeatherViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    internal let cache: ImageCache
    internal let api: ImageRetrieverImpl
    
    init(api: ImageRetrieverImpl = ImageRetriever(), cache: ImageCache = .shared, collectionViewLayout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.api = api
        self.cache = cache
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCV()
    }
    
    /// Handles view orientation - landscape or portrait
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupCV() {
        collectionView.register(WeatherCell.self, forCellWithReuseIdentifier: ReuseId.weatherCell)
        collectionView.register(WeatherExtraDetailCell.self, forCellWithReuseIdentifier: ReuseId.weatherExtraDetailCell)

        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = false
        collectionView.showsVerticalScrollIndicator = false
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 5
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm != nil ? WeatherViews.allCases.count : 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = WeatherViews.allCases[indexPath.item]
        switch view {
        case .weather:
            let weatherCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.weatherCell, for: indexPath) as! WeatherCell
            weatherCell.weatherLabel.attributedText = vm?.getWeatherAttributedText()
            return weatherCell
        case .weatherExtraDetail:
            let weatherExtraDetailCell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseId.weatherExtraDetailCell, for: indexPath) as! WeatherExtraDetailCell
            weatherExtraDetailCell.detailLabel.attributedText = vm?.getExtraDetailAttributedText()
            return weatherExtraDetailCell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if
            let weatherCell = cell as? WeatherCell,
            let code = vm?.icon
        {
            Task {
                await weatherCell.weatherImageView.loadIcon(code: code, api: api, cache: cache)
            }
        }
    }
    
}

extension WeatherController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let view = WeatherViews.allCases[indexPath.item]
        switch view {
        case .weather:
            let size = CGSize(width: collectionView.frame.width - 40 - 32, height: 1000)
            let height = (vm?.getWeatherAttributedText().boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height ?? 0) + 32
            return CGSize(width: collectionView.frame.width, height: height)
        case .weatherExtraDetail:
            let size = CGSize(width: collectionView.frame.width - 32, height: 1000)
            let height = (vm?.getExtraDetailAttributedText().boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height ?? 0) + 32
            return CGSize(width: collectionView.frame.width, height: height)
        }
    }
}

extension WeatherController {
    enum ReuseId {
        static let weatherCell = "cWeatherCell"
        static let weatherExtraDetailCell = "cWeatherExtraDetailCell"
    }
}

extension WeatherController {
    
    /// Each case represents a cell for the WeatherController+CV
    ///
    /// Depending on case, a unique UICollectionViewCell can be used to display different views/information
    enum WeatherViews: CaseIterable {
        case weather
        case weatherExtraDetail
    }
}
