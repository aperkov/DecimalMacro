import Foundation
import RegexBuilder
import SwiftSyntax
import SwiftSyntaxMacros

/// Implementation of the `decimal` macro.
public struct DecimalMacro: ExpressionMacro {

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

        guard let argument = parseArgument(argumentAsString) else {
            throw DecimalMacroError.unsupportedArgument(argumentAsString)
        }

        return
            "Decimal(sign: .\(raw: argument.sign), exponent: \(raw: argument.exponent), significand: \(raw: argument.significand))"
    }

    private static func parseArgument(_ value: String) -> Decimal? {
        // By the time we get here the Swift compiler has already verified that `value` is a valid `FloatLiteralType`.
        //
        // However the `Decimal` initialiser we use consumes decimal literal characters and then ignores unknown
        // trailing characters (like the C `atof` function). This means it will produce an incorrect result for binary,
        // octal, or hexadecimal literals. For now we reject these so the user gets a compile time error.

        let valueWithoutGrouping = value.replacing("_", with: "")

        let invalidChars = Regex {
            CharacterClass(
                .digit,
                .anyOf("+-.eE")
            )
            .inverted
        }

        guard !valueWithoutGrouping.contains(invalidChars) else {
            return nil
        }

        return Decimal(string: valueWithoutGrouping)
    }

}
