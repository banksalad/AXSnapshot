//
//  AccessibilityDescription.swift
//  
//
//  Created by Sungdoo on 2022/03/12.
//

import Foundation
import UIKit

/// generateAccessibilityDescription for Single accessibleElement
///
/// Replace this closure to generate your custom snapshot format
public var generateAccessibilityDescription: (NSObject) -> String = { object in
    var description = ""
    
    if let label = object.accessibilityLabel, label.count > 0 {
        description += label
    }
    
    if let value = object.accessibilityValue, value.count > 0 {
        if description.count > 0 {
            description += ", "
        }
        description += value
    }

    if object.accessibilityTraits.isEmpty == false {
        description += "\n"
        description += object.accessibilityTraits.descripion
    }

    if let hint = object.accessibilityHint {
        description += "\n"
        description += hint
    }

    if let actions = object.accessibilityCustomActions {
        description += "\n"
        description += "Actions: "
        description += actions.map { $0.name }.joined(separator: ", ")
    }

    return description
}

extension NSObject {
    var accessibilityDescription: String {
        generateAccessibilityDescription(self)
    }
}
