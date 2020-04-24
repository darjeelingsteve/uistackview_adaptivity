//
//  TableStyleLayoutMetrics.swift
//  CountiesUI iOS
//
//  Created by Stephen Anthony on 23/04/2020.
//  Copyright © 2020 Darjeeling Apps. All rights reserved.
//

import UIKit

/// A struct representing the various layout metrics used when laying out a
/// collection view in a grouped table style for a given content size category.
struct TableStyleLayoutMetrics {
    private static let defaultContentSizeCategory: UIContentSizeCategory = .large
    
    private let contentSizeCategory: UIContentSizeCategory
    
    init(contentSizeCategory: UIContentSizeCategory) {
        self.contentSizeCategory = contentSizeCategory
    }
    
    /// The height to use for table style cells.
    var cellHeight: CGFloat {
        switch contentSizeCategory {
        case .extraSmall, .small, .medium, .large, .unspecified:
            return 44
        case .extraLarge:
            return 48
        case .extraExtraLarge:
            return 52
        case .extraExtraExtraLarge:
            return 58
        case .accessibilityMedium:
            return 69
        case .accessibilityLarge:
            return 81
        case .accessibilityExtraLarge:
            return 97
        case .accessibilityExtraExtraLarge:
            return 114
        case .accessibilityExtraExtraExtraLarge:
            return 127
        default:
            return TableStyleLayoutMetrics(contentSizeCategory: TableStyleLayoutMetrics.defaultContentSizeCategory).cellHeight
        }
    }
    
    /// The font to use for section headers.
    var sectionHeaderFont: UIFont {
        switch contentSizeCategory {
        case .extraSmall, .small, .medium:
            return .systemFont(ofSize: 12, weight: .regular)
        case .large:
            return .systemFont(ofSize: 13, weight: .regular)
        case .extraLarge:
            return .systemFont(ofSize: 15, weight: .regular)
        case .extraExtraLarge:
            return .systemFont(ofSize: 17, weight: .regular)
        case .extraExtraExtraLarge:
            return .systemFont(ofSize: 19, weight: .regular)
        case .accessibilityMedium:
            return .systemFont(ofSize: 23, weight: .regular)
        case .accessibilityLarge:
            return .systemFont(ofSize: 27, weight: .regular)
        case .accessibilityExtraLarge:
            return .systemFont(ofSize: 33, weight: .regular)
        case .accessibilityExtraExtraLarge:
            return .systemFont(ofSize: 38, weight: .regular)
        case .accessibilityExtraExtraExtraLarge:
            return .systemFont(ofSize: 44, weight: .regular)
        case .unspecified:
            fallthrough
        default:
            return TableStyleLayoutMetrics(contentSizeCategory: TableStyleLayoutMetrics.defaultContentSizeCategory).sectionHeaderFont
        }
    }
    
    /// The height to use for section headers.
    var sectionHeaderHeight: CGFloat {
        switch contentSizeCategory {
        case .extraSmall, .small, .medium:
            return 32
        case .large:
            return 38
        case .extraLarge:
            return 44
        case .extraExtraLarge:
            return 50
        case .extraExtraExtraLarge:
            return 56
        case .accessibilityMedium:
            return 72
        case .accessibilityLarge:
            return 84
        case .accessibilityExtraLarge:
            return 105
        case .accessibilityExtraExtraLarge:
            return 124
        case .accessibilityExtraExtraExtraLarge:
            return 142
        case .unspecified:
            fallthrough
        default:
            return TableStyleLayoutMetrics(contentSizeCategory: TableStyleLayoutMetrics.defaultContentSizeCategory).sectionHeaderHeight
        }
    }
    
    /// The padding to apply between the bottom of the section header title
    /// label and the bottom of the section header view.
    var sectionHeaderLabelBottomPadding: CGFloat {
        switch contentSizeCategory {
        case .extraSmall, .small, .medium:
            return 6
        case .large:
            return 7
        case .extraLarge, .extraExtraLarge:
            return 8
        case .extraExtraExtraLarge:
            return 9
        case .accessibilityMedium, .accessibilityLarge:
            return 11
        case .accessibilityExtraLarge:
            return 14
        case .accessibilityExtraExtraLarge:
            return 17
        case .accessibilityExtraExtraExtraLarge:
            return 18
        case .unspecified:
            fallthrough
        default:
            return TableStyleLayoutMetrics(contentSizeCategory: TableStyleLayoutMetrics.defaultContentSizeCategory).sectionHeaderLabelBottomPadding
        }
    }
    
    /// The padding to apply to the bottom of a section.
    /// - Parameter sectionIsLastSection: A `Boolean` value indicating whether
    /// the padding is for the last section in the collection view or not.
    /// - Returns: The height to use for the section's bottom padding.
    func sectionBottomPadding(forSectionThatIsTheLastSection sectionIsLastSection: Bool) -> CGFloat {
        return sectionIsLastSection ? 38 : 18
    }
}
