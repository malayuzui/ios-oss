import Foundation

final class AttributedNumberFormatter: NumberFormatter {
  // MARK: - Properties

  var defaultAttributes: [NSAttributedString.Key: Any] = [:]
  var currencySymbolAttributes: [NSAttributedString.Key: Any] = [:]
  var decimalSeparatorAttributes: [NSAttributedString.Key: Any] = [:]
  var fractionDigitsAttributes: [NSAttributedString.Key: Any] = [:]

  // MARK: - Attributed string

  // swiftlint:disable:next line_length
  override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedString.Key: Any]? = nil) -> NSAttributedString? {
    guard let number = obj as? NSNumber, let string = string(from: number) else { return nil }

    let mutableAttributedString = NSMutableAttributedString(
      string: string,
      attributes: self.defaultAttributes
    )

    // swiftlint:disable:next line_length
    if let currencySymbolRange = currencySymbolRange(for: string), currencySymbolRange.location != NSNotFound {
      mutableAttributedString.addAttributes(
        self.currencySymbolAttributes,
        range: currencySymbolRange
      )
    }

    // swiftlint:disable:next line_length
    if let decimalSeparatorRange = self.decimalSeparatorRange(for: string), decimalSeparatorRange.location != NSNotFound {
      mutableAttributedString.addAttributes(
        self.decimalSeparatorAttributes,
        range: decimalSeparatorRange
      )
    }

    // swiftlint:disable:next line_length
    if let fractionDigitsRange = self.fractionDigitsRange(for: string), fractionDigitsRange.location != NSNotFound {
      mutableAttributedString.addAttributes(
        self.fractionDigitsAttributes,
        range: fractionDigitsRange
      )
    }

    return NSAttributedString(attributedString: mutableAttributedString)
  }

  // MARK: - Ranges

  private func currencySymbolRange(for string: String) -> NSRange? {
    return self.numberStyle == .currency ? (string as NSString).range(of: self.currencySymbol) : nil
  }

  private func decimalSeparatorRange(for string: String) -> NSRange? {
    return self.maximumFractionDigits > 0 ? (string as NSString).range(of: self.decimalSeparator) : nil
  }

  private func fractionDigitsRange(for string: String) -> NSRange? {
    // swiftlint:disable:next line_length
    if let decimalSeparatorRange = self.decimalSeparatorRange(for: string), decimalSeparatorRange.location != NSNotFound {
      return NSRange(
        location: decimalSeparatorRange.location + 1,
        length: self.maximumFractionDigits
      )
    } else {
      return nil
    }
  }
}
