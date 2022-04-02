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
    var description = generateAccessbilityLabelDescription(object)

    let accessibilityValueDescription = generateAccessibilityValueDescription(object)
    if accessibilityValueDescription.count > 0, description.count > 0 {
        description += ", "
    }
    description += accessibilityValueDescription

    description += generateAccessibilityTraitDescription(object)
    description += generateAccessibilityHintDescription(object)
    description += generateAccessibilityCustomActionsDescription(object)

    return description
}

public var generateAccessbilityLabelDescription: (NSObject) -> String = { object in
    var description = ""
    if let label = object.accessibilityLabel, label.count > 0 {
        description = label
    }

    return description
}

public var generateAccessibilityValueDescription: (NSObject) -> String = { object in
    var description = ""
    if let value = object.accessibilityValue, value.count > 0 {
        description = value
    }
    return description
}

public var generateAccessibilityTraitDescription: (NSObject) -> String = { object in
    var description = ""
    if object.accessibilityTraits.isEmpty == false {
        description = "\n\(object.accessibilityTraits.descripion)"
    }
    return description
}

public var generateAccessibilityHintDescription: (NSObject) -> String = { object in
    var description = ""
    if let hint = object.accessibilityHint {
        description = "\n\(hint)"
    }
    return description
}

public var generateAccessibilityCustomActionsDescription: (NSObject) -> String = { object in
    var description = ""
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
