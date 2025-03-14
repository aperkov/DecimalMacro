import DecimalMacroImpl
import SwiftSyntaxMacrosTestSupport
import XCTest

final class DecimalMacroTests: XCTestCase {

  private let testMacros = ["decimal": DecimalMacro.self]

  func testMacroExpansion() {
    assertMacroExpansion(
      "#decimal(3.24)", expandedSource: "Decimal(string: \"3.24\")!", macros: testMacros)
    assertMacroExpansion(
      "#decimal(-7.14)", expandedSource: "Decimal(string: \"-7.14\")!", macros: testMacros)

    assertMacroExpansion(
      "#decimal(0.0)", expandedSource: "Decimal(string: \"0.0\")!", macros: testMacros)
    assertMacroExpansion(
      "#decimal(-0.0)", expandedSource: "Decimal(string: \"-0.0\")!", macros: testMacros)

    assertMacroExpansion(
      "#decimal(3)", expandedSource: "Decimal(string: \"3\")!", macros: testMacros)
    assertMacroExpansion(
      "#decimal(-7)", expandedSource: "Decimal(string: \"-7\")!", macros: testMacros)

    assertMacroExpansion(
      "#decimal(0)", expandedSource: "Decimal(string: \"0\")!", macros: testMacros)
    assertMacroExpansion(
      "#decimal(-0)", expandedSource: "Decimal(string: \"-0\")!", macros: testMacros)
  }

  func testMacroFailure() {
    assertMacroExpansion(
      "#decimal()",
      expandedSource: "#decimal()",
      diagnostics: [
        DiagnosticSpec(message: "No arguments received", line: 1, column: 1)
      ],
      macros: testMacros)

    assertMacroExpansion(
      "#decimal(Double.nan)",
      expandedSource: "#decimal(Double.nan)",
      diagnostics: [
        DiagnosticSpec(
          message: "Unsupported argument type: MemberAccessExprSyntax", line: 1, column: 1)
      ],
      macros: testMacros)
  }

}
