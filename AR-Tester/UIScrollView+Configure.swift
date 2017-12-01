//
//  UIScrollView+Configure.swift
//  AR-Tester
//
//  Created by Egor Petrov on 30/11/2017.
//  Copyright © 2017 Peter Savchenko. All rights reserved.
//

import UIKit

private var associationKey = "scrollView_bottom_inset"

struct ScrollViewConfiguration {
    var topInset: CGFloat?
    var bottomInset: CGFloat?
    var bottomIndicatorInset: CGFloat?

    init(topInset: CGFloat? = nil,
         bottomInset: CGFloat? = nil,
         bottomIndicatorInset: CGFloat? = nil) {
        self.topInset = topInset
        self.bottomInset = bottomInset
        self.bottomIndicatorInset = bottomIndicatorInset
    }

    static var `default` = defaultConfiguration
}

private var defaultConfiguration: ScrollViewConfiguration {
    return ScrollViewConfiguration(topInset: 0, 
                                   bottomInset: 0)
}

extension UIScrollView {
    private(set) var defaultBottomInset: CGFloat {
        get {
            return (objc_getAssociatedObject(self, &associationKey) as? CGFloat) ?? defaultConfiguration.bottomInset!
        }
        set {
            objc_setAssociatedObject(self, &associationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }

    enum ConfigurationType {
        case defaultConfiguration
        case custom(ScrollViewConfiguration)
    }

    func configure(with configuration: ConfigurationType) {
        switch configuration {
        case .defaultConfiguration:
            setup(configuration: defaultConfiguration)
        case let .custom(customConfig):
            setup(configuration: customConfig)
        }
    }

    private func setup(configuration: ScrollViewConfiguration) {
        if let topInset = configuration.topInset {
            self.contentInset.top = topInset
        }
        if let bottomInset = configuration.bottomInset {
            self.contentInset.bottom = bottomInset
            defaultBottomInset = bottomInset
        }
        if let bottomIndicatorInset = configuration.bottomIndicatorInset {
            self.scrollIndicatorInsets.bottom = bottomIndicatorInset
        }
    }
}

