import DecimalMacroImpl
import SwiftSyntaxMacrosTestSupport
import XCTest

final class DecimalMacroTests: XCTestCase {

    private let testMacros = ["decimal": DecimalMacro.self]

    func testMacroExpandsGivenDecimalFloatingPointLiteral() {
        assertMacroExpansion(
            "#decimal(3.24)",
            expandedSource: "Decimal(sign: .plus, exponent: -2, significand: 324)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(+1.001)",
            expandedSource: "Decimal(sign: .plus, exponent: -3, significand: 1001)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-7.141)",
            expandedSource: "Decimal(sign: .minus, exponent: -3, significand: 7141)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0.0)",
            expandedSource: "Decimal(sign: .plus, exponent: -1, significand: 0)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-0.0)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 0)",  // `Decimal` can't represent -0
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1_234.5)",
            expandedSource: "Decimal(sign: .plus, exponent: -1, significand: 12345)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23e4)",
            expandedSource: "Decimal(sign: .plus, exponent: 2, significand: 123)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23e+4)",
            expandedSource: "Decimal(sign: .plus, exponent: 2, significand: 123)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23E-2)",
            expandedSource: "Decimal(sign: .plus, exponent: -4, significand: 123)",
            macros: testMacros
        )
    }

    func testMacroExpandsGivenDecimalIntegerLiteral() {
        assertMacroExpansion(
            "#decimal(3)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 3)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(+5)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 5)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-7)",
            expandedSource: "Decimal(sign: .minus, exponent: 0, significand: 7)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 0)",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-0)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 0)",  // `Decimal` can't represent -0
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1_234)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: 1234)",
            macros: testMacros
        )
    }

    func testMacroFailsGivenNoArguments() {
        assertMacroExpansion(
            "#decimal()",
            expandedSource: "#decimal()",
            diagnostics: [
                DiagnosticSpec(message: "No arguments received", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenNonDecimalFloatingPointLiteral() {
        // `DecimalMacro` only supports decimal floating point literals. The following will fail:
        // - Hexadecimal literals such as `0xA.Bp2` (decimal `42.75`).

        assertMacroExpansion(
            "#decimal(0xA.Bp2)",
            expandedSource: "#decimal(0xA.Bp2)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot parse '0xA.Bp2' as a 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenNonDecimalIntegerLiteral() {
        // `DecimalMacro` only supports decimal integer literals. The following will fail:
        // - Binary literals such as `0b101` (decimal `5`).
        // - Octal Literals such as `0o123` (decimal `83`).
        // - Hexadecimal literals such as `0xABC` (decimal `2748`).

        assertMacroExpansion(
            "#decimal(0b101)",
            expandedSource: "#decimal(0b101)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot parse '0b101' as a 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0o123)",
            expandedSource: "#decimal(0o123)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot parse '0o123' as a 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0xABC)",
            expandedSource: "#decimal(0xABC)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot parse '0xABC' as a 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenDoubleConstant() {
        assertMacroExpansion(
            "#decimal(Double.nan)",
            expandedSource: "#decimal(Double.nan)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot parse 'Double.nan' as a 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

}
