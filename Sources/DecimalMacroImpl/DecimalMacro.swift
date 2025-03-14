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
  public static func expansion(
    of node: some FreestandingMacroExpansionSyntax,
    in context: some MacroExpansionContext
  ) throws -> ExprSyntax {

    guard let argumentExpression = node.arguments.first?.expression else {
      throw DecimalMacroError.noArguments
    }

    guard isNumericLiteral(argumentExpression) || isPrefixedNumericLiteral(argumentExpression)
    else {
      throw DecimalMacroError.unsupportedArgumentType(argumentExpression.syntaxNodeType)
    }

    return "Decimal(string: \"\(argumentExpression)\")!"
  }

  private static func isNumericLiteral(_ expression: ExprSyntax) -> Bool {
    expression.is(FloatLiteralExprSyntax.self) || expression.is(IntegerLiteralExprSyntax.self)
  }

  private static func isPrefixedNumericLiteral(_ expression: ExprSyntax) -> Bool {
    guard let prefixOperator = expression.as(PrefixOperatorExprSyntax.self) else {
      return false
    }

    return isNumericLiteral(prefixOperator.expression)
  }

}
