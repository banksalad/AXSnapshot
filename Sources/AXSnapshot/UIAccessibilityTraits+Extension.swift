//
//  File.swift
//  
//
//  Created by Sungdoo on 2022/03/12.
//

import Foundation
import UIKit

extension UIAccessibilityTraits {
    var descripion: String {
        var traits: [String] = []

        if self.contains(.button) {
            traits.append("button")
        }

        if self.contains(.link) {
            traits.append("link")
        }

        if self.contains(.image) {
            traits.append("image")
        }

        if self.contains(.searchField) {
            traits.append("searchField")
        }

        if self.contains(.keyboardKey) {
            traits.append("keyboardKey")
        }

        if self.contains(.staticText) {
            traits.append("staticText")
        }

        if self.contains(.header) {
            traits.append("header")
        }

        if #available(iOS 10.0, *) {
            if self.contains(.tabBar) {
                traits.append("tabBar")
            }
        }

        if self.contains(.summaryElement) {
            traits.append("summaryElement")
        }

        if self.contains(.selected) {
            traits.append("selected")
        }

        if self.contains(.notEnabled) {
            traits.append("notEnabled")
        }

        if self.contains(.adjustable) {
            traits.append("adjustable")
        }

        if self.contains(.allowsDirectInteraction) {
            traits.append("allowsDirectInteraction")
        }

        if self.contains(.updatesFrequently) {
            traits.append("updatesFrequently")
        }

        if self.contains(.causesPageTurn) {
            traits.append("causesPageTurn")
        }

        if self.contains(.playsSound) {
            traits.append("playsSound")
        }

        if self.contains(.startsMediaSession) {
            traits.append("startsMediaSession")
        }

        return traits.joined(separator: ", ")
    }
}
