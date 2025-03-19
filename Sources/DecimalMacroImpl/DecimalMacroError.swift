import Foundation
import SwiftSyntax

/// Errors thrown when expanding the `decimal` macro.
public enum DecimalMacroError: Error, CustomStringConvertible {

    /// The macro did not receive any arguments.
    case noArguments

    /// The macro received an unsupported argument.
    case unsupportedArgument(String)

    /// A textual representation of this error.
    public var description: String {
        switch self {
            case .noArguments: "No arguments received"
            case .unsupportedArgument(let value): "Cannot parse '\(value)' as a 'Decimal'"
        }
    }

}
