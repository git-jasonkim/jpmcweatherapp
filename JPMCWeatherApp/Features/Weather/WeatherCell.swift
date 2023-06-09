//
//  WeatherCell.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
        weatherLabel.attributedText = nil
    }
    
    public lazy var weatherImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = .systemTeal
        iv.layer.cornerRadius = 4
        iv.layer.masksToBounds = true
        return iv
    }()
    
    public lazy var weatherLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private func setupSubviews() {
        backgroundColor = .lightGray
        addSubview(weatherImageView)
        weatherImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, paddingTop: 16, paddingLeading: 16, paddingBottom: 16, paddingTrailing: 0, width: 50, height: 0)
        
        addSubview(weatherLabel)
        weatherLabel.anchor(centerX: nil, centerY: weatherImageView.centerYAnchor, top: nil, leading: weatherImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, paddingTop: 0, paddingLeading: 16, paddingBottom: 0, paddingTrailing: 16, width: 0, height: 0)
    }
    
}
