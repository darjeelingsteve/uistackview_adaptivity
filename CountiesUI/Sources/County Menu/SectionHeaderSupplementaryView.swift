//
//  SectionHeaderSupplementaryView.swift
//  CountiesUI
//
//  Created by Stephen Anthony on 15/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// A supplementary view used to display a section header in a collection view.
class SectionHeaderSupplementaryView: UICollectionReusableView {
    
    /// The title displayed by the receiver.
    var title: String? {
        didSet {
            configureTitleLabel()
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        return titleLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonSetup()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        configureTitleLabel()
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        super.updateConstraints()
    }
    
    private func commonSetup() {
        #if os(iOS)
        backgroundColor = .systemGroupedBackground
        #endif
        addSubview(titleLabel)
        configureTitleLabel()
        preservesSuperviewLayoutMargins = true
    }
    
    private func configureTitleLabel() {
        #if os(iOS)
        let isRegularWidth = traitCollection.horizontalSizeClass == .regular
        titleLabel.text = isRegularWidth ? title : title?.uppercased()
        titleLabel.font = isRegularWidth ? .systemFont(ofSize: 22, weight: .bold) : .systemFont(ofSize: 13, weight: .regular)
        titleLabel.textColor = UIColor(dynamicProvider: { (traitCollection) -> UIColor in
            guard traitCollection.horizontalSizeClass == .compact else {
                return .label
            }
            if traitCollection.userInterfaceStyle == .light {
                return UIColor(red: 0.43, green: 0.43, blue: 0.45, alpha: 1)
            }
            return UIColor(red: 0.56, green: 0.56, blue: 0.58, alpha: 1)
        })
        #elseif os(tvOS)
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 40, weight: .bold)
        #endif
    }
}
