//
//  Constants.swift
//  JPMCWeatherApp
//
//  Created by Jason Kim on 6/8/23.
//

import UIKit

enum Constants { }

extension Constants {
    enum Padding {
        static var leftSafeArea: CGFloat {
            return ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.left ?? .zero)
        }
        static var rightSafeArea: CGFloat {
            return ((UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.safeAreaInsets.right ?? .zero)
        }
    }
}
