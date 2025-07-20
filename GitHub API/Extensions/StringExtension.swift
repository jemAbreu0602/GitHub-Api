//
//  StringExtension.swift
//  GitHub API
//
//  Created by Jem Abreu on 7/18/25.
//
import Foundation
import UIKit

extension String {
    var bearer: String {
        return "Bearer \(self)"
    }

    func toAttributedLabel(value: String, labelColor: UIColor, valueColor: UIColor) -> NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: self, attributes: [.foregroundColor: labelColor])
        guard let range = self.range(of: value) else { return attrString }
        var nsRange = NSRange(range, in: self)
        nsRange.length = self.count - nsRange.location
        attrString.addAttribute(.foregroundColor, value: valueColor, range: nsRange)
        return attrString
    }
}

extension Int {
    func compactFormat() -> String {
        let defaultStyle = IntegerFormatStyle<Int>(locale: .current)
        let style = defaultStyle.notation(.compactName)
        return self.formatted(style)
    }
}
