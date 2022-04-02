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

        // accessibilityTraits of UITextView and UITextFields are not declared as constant.
        // - Date: 2022.04.02
        if rawValue == 262_144 {
            traits.append("text field")
        }

        if rawValue == 140_737_488_617_472 {
            traits.append("text view")
        }

        return traits.joined(separator: ", ")
    }
}
