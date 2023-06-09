//
//  WeatherExtraDetailCell.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

class WeatherExtraDetailCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        detailLabel.attributedText = nil
    }
    
    public lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private func setupSubviews() {
        backgroundColor = .systemTeal
        addSubview(detailLabel)
        detailLabel.anchor(centerX: nil, centerY: centerYAnchor, top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, paddingTop: 0, paddingLeading: 16, paddingBottom: 0, paddingTrailing: 16, width: 0, height: 0)

    }
    
}
