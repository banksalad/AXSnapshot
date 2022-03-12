import UIKit

public extension UIView {
    /// Generate text-formatted snapshot of accessibility experience
    func axSnapshot() -> String {

        let descriptions = exposedAccessibleViews().map { element in
            element.accessibilityDescription
        }
        
        if descriptions.isEmpty {
            return ""
        } else {
            let seperator = "------------------------------------------------------------"
            var description = seperator + "\n"
            description += descriptions.joined(separator: "\n\(seperator)\n")
            description += "\n\(seperator)"
            return description
        }
    }
    
    /// List of all subviews that are accessible via assistive technology such as VoiceOver
    func exposedAccessibleViews() -> [UIView] {
        var allCandidate = allSubviews
        allCandidate.insert(self, at: 0)
        return allCandidate.filter { $0.isExposedToAssistiveTech }
    }
}

public extension UIViewController {
    /// Generate text-formatted snapshot of accessibility experience
    func axSnapshot() -> String {
        view.axSnapshot()
    }
}

extension UIView {
    /// List of all subviews in view tree
    var allSubviews: [UIView] {
        return self.subviews.flatMap { [$0] + $0.allSubviews }
    }
}
