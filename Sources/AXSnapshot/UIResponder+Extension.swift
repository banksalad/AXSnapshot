//
//  UIResponder+Extension.swift
//  
//
//  Created by Sungdoo on 2022/03/12.
//

import Foundation
import UIKit

extension UIResponder {
    var isExposedToAssistiveTech: Bool {
        if isAccessibilityElement {
            if allResponderChain.contains(where: { $0.isExposedToAssistiveTech }) == true {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }

    var allResponderChain: [UIResponder] {
        var chain = [UIResponder]()
        var nextResponder = next
        while nextResponder != nil {
            chain.append(nextResponder!)
            nextResponder = nextResponder?.next
        }
        return chain
    }
}
