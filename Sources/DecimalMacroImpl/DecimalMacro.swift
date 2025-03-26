import Foundation
import SwiftSyntax
import SwiftSyntaxMacros

/// Implementation of the `decimal` macro.
public struct DecimalMacro: ExpressionMacro {

    /// The locale used for formatting and parsing strings.
    private static let locale = Locale(identifier: "en_US")

    /// The format styles used to verify that literals have been parsed correctly.
    private static let formatStyles = createFormatStyles()

    /// Expands the `decimal` macro.
    ///
    /// - Parameters:
    ///   - node: The macro to be expanded.
    ///   - context: The macro's context.
    /// - Returns: The expanded macro.
    /// - Throws: A ``DecimalMacroError`` if the macro can't be expanded.
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) throws -> ExprSyntax {

        guard let argumentAsString = node.arguments.first?.expression.description else {
            throw DecimalMacroError.noArguments
        }

        guard let argumentAsDecimal = parseArgument(argumentAsString) else {
            throw DecimalMacroError.unsupportedArgument(argumentAsString)
        }

        return argumentAsDecimal.significand <= Decimal(UInt64.max)
            ? toSimpleExpression(argumentAsDecimal)
            : toFullExpression(argumentAsDecimal)
    }

    private static func parseArgument(_ valueAsRawString: String) -> Decimal? {
        // By the time macro expansion occurs the Swift compiler will have verified that `valueAsRawString` is a valid
        // `FloatLiteralType`.
        //
        // However the `Decimal` initialiser `init(string:locale:)` isn't strict when parsing, which leads to incorrect
        // behaviour for:
        //
        // 1. binary, octal, or hexadecimal literals.
        // 2. literals that would require the significand to be greater than 2^128 - 1.
        // 3. literals that would require the exponent to be greater than 2^7 - 1 or less than -2^7.
        //
        // To prevent incorrect runtime behaviour we verify that the parsed `Decimal` accurately represents the supplied
        // literal by ensuring that we can reproduce the literal as a string.

        let valueAsString = normaliseArgument(valueAsRawString)

        guard
            let valueAsDecimal = Decimal(string: valueAsString, locale: locale),
            canReproduce(valueAsString, from: valueAsDecimal)
        else {
            return nil
        }

        return valueAsDecimal
    }

    private static func normaliseArgument(_ valueAsString: String) -> String {
        valueAsString
            .replacing("_", with: "")  // '_' is not supported by `Decimal.init(string:locale:)`, but not needed.
            .replacing("+", with: "")  // '+' on exponents is not supported by `canReproduce`, but not needed.
            .replacing("e", with: "E")  // 'e' is not canonical for the "en_US" locale, use 'E' instead.
    }

    private static func canReproduce(_ valueAsString: String, from valueAsDecimal: Decimal) -> Bool {
        formatStyles.contains { formatStyle in
            valueAsString == valueAsDecimal.formatted(formatStyle)
        }
    }

    private static func createFormatStyles() -> [Decimal.FormatStyle] {
        let floatStyle = Decimal.FormatStyle().locale(locale).grouping(.never).precision(.fractionLength(1 ... Int.max))
        let intStyle = floatStyle.precision(.fractionLength(0))
        let scientificFloatStyle = floatStyle.notation(.scientific)
        let scientificIntStyle = intStyle.notation(.scientific)

        return [floatStyle, intStyle, scientificFloatStyle, scientificIntStyle]
    }

    private static func toSimpleExpression(_ value: Decimal) -> ExprSyntax {
        // Produces the expanded output when the significand is less than or equal to `UInt64.max` (i.e. 2^64 - 1). This
        // is preferred because the expanded output is much more readable.

        "Decimal(sign: .\(raw: value.sign), exponent: \(raw: value.exponent), significand: Decimal(\(raw: value.significand) as UInt64))"
    }

    private static func toFullExpression(_ value: Decimal) -> ExprSyntax {
        // Produces the expanded output when the significand is greater than `UInt64.max` (i.e. 2^64 - 1). The expanded
        // output is hard to read, but supports significands up to 2^128 - 1.

        "Decimal(_exponent: \(raw: value._exponent), _length: \(raw: value._length), _isNegative: \(raw: value._isNegative), _isCompact: \(raw: value._isCompact), _reserved: \(raw: value._reserved), _mantissa: \(raw: value._mantissa))"
    }

}
