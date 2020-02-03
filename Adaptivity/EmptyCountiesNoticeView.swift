//
//  EmptyCountiesNoticeView.swift
//  Counties
//
//  Created by Stephen Anthony on 03/02/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// The view used in the counties view when there are no counties to show.
final class EmptyCountiesNoticeView: UIView {
    
    /// The struct used to configure `EmptyCountiesNoticeView` based on the
    /// style of the counties view that contains it, and the current search
    /// term (if any).
    struct Configuration {
        let style: CountiesViewController.Style
        let searchQuery: String?
    }
    
    /// The receiver's current configuration.
    var configuration: Configuration? {
        didSet {
            titleLabel.text = configuration?.title
            messageLabel.text = configuration?.message
        }
    }
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .preferredFont(forTextStyle: .headline)
        titleLabel.textColor = .secondaryLabel
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontForContentSizeCategory = true
        return titleLabel
    }()
    
    private let messageLabel: UILabel = {
        let messageLabel = UILabel()
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.font = .preferredFont(forTextStyle: .body)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.adjustsFontForContentSizeCategory = true
        messageLabel.numberOfLines = 0
        return messageLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(messageLabel)
        layoutMargins = .zero
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor)
        ])
        NSLayoutConstraint.activate([
            messageLabel.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            messageLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: titleLabel.lastBaselineAnchor, multiplier: 1),
            messageLabel.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
        super.updateConstraints()
    }
}

private extension EmptyCountiesNoticeView.Configuration {
    var title: String {
        if searchQuery != nil && searchQuery?.isEmpty == false {
            return NSLocalizedString("No results", comment: "Empty counties no search results title")
        }
        switch style {
        case .allCounties:
            return NSLocalizedString("No Counties", comment: "Empty counties \"all counties\" title")
        case .favourites:
            return NSLocalizedString("No Favourites", comment: "Empty counties \"favourites\" title")
        }
    }
    
    var message: String {
        guard let searchQuery = searchQuery, searchQuery.isEmpty == false else {
            switch style {
            case .allCounties:
                return NSLocalizedString("It appears no counties were loaded.", comment: "Empty counties \"all counties\" message")
            case .favourites:
                return NSLocalizedString("You do not have any favourite counties. To create favourite counties, go to the \"All Counties\" tab, tap on a county to view it, and tap on the favourite button.", comment: "Empty counties \"favourites\" message")
            }
        }
        return String(format: NSLocalizedString("No counties found for \"%@\".", comment: "Empty counties search text message"), searchQuery)
    }
}
