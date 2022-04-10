//
//  UIAccessibilityTraits+Extension.swift
//
//
//  Created by Sungdoo on 2022/03/12.
//

import Foundation
import UIKit

extension UIAccessibilityTraits {
    var descripion: String {
        guard isStandardTraits else { return "" }

        var traits: [String] = []

        if contains(.button) {
            traits.append("button")
        }

        if contains(.link) {
            traits.append("link")
        }

        if contains(.image) {
            traits.append("image")
        }

        if contains(.searchField) {
            traits.append("searchField")
        }

        if contains(.keyboardKey) {
            traits.append("keyboardKey")
        }

        if contains(.staticText) {
            traits.append("staticText")
        }

        if contains(.header) {
            traits.append("header")
        }

        if #available(iOS 10.0, *) {
            if self.contains(.tabBar) {
                traits.append("tabBar")
            }
        }

        if contains(.summaryElement) {
            traits.append("summaryElement")
        }

        if contains(.selected) {
            traits.append("selected")
        }

        if contains(.notEnabled) {
            traits.append("notEnabled")
        }

        if contains(.adjustable) {
            traits.append("adjustable")
        }

        if contains(.allowsDirectInteraction) {
            traits.append("allowsDirectInteraction")
        }

        if contains(.updatesFrequently) {
            traits.append("updatesFrequently")
        }

        if contains(.causesPageTurn) {
            traits.append("causesPageTurn")
        }

        if contains(.playsSound) {
            traits.append("playsSound")
        }

        if contains(.startsMediaSession) {
            traits.append("startsMediaSession")
        }

        return traits.joined(separator: ", ")
    }

    var isStandardTraits: Bool {
        var standardAccessibilityTraits = UIAccessibilityTraits(arrayLiteral: [
            .adjustable,
            .allowsDirectInteraction,
            .button,
            .causesPageTurn,
            .header,
            .image,
            .keyboardKey,
            .link,
            .none,
            .notEnabled,
            .playsSound,
            .selected,
            .staticText,
            .searchField,
            .summaryElement,
            .startsMediaSession,
            .updatesFrequently,
        ])

        if #available(iOS 10, *) {
            standardAccessibilityTraits.insert(.tabBar)
        }
        return isStrictSubset(of: standardAccessibilityTraits)
    }
}
