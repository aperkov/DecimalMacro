import Foundation
import SwiftSyntax

/// Errors thrown when expanding the `decimal` macro.
public enum DecimalMacroError: Error, CustomStringConvertible {

  /// The macro did not receive any arguments.
  case noArguments

  /// The macro received an unsupported argument.
  case unsupportedArgumentType(SyntaxProtocol.Type)

  /// A textual representation of this error.
  public var description: String {
    switch self {
    case .noArguments:
      "No arguments received"

    case .unsupportedArgumentType(let syntaxNodeType):
      "Unsupported argument type: \(syntaxNodeType)"
    }
  }

}
