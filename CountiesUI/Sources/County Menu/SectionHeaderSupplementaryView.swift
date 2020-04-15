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
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: platformValue(foriOS: 22, tvOS: 40), weight: .bold)
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
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        super.updateConstraints()
    }
    
    private func commonSetup() {
        #if os(iOS)
        backgroundColor = .systemBackground
        #endif
        addSubview(titleLabel)
    }
}
