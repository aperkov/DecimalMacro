import DecimalMacroImpl
import SwiftSyntaxMacrosTestSupport
import XCTest

final class DecimalMacroTests: XCTestCase {

    private let testMacros = ["decimal": DecimalMacro.self]

    func testMacroExpandsGivenDecimalFloatingPointLiteral() {
        assertMacroExpansion(
            "#decimal(3.24)",
            expandedSource: "Decimal(sign: .plus, exponent: -2, significand: Decimal(324 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(+1.001)",
            expandedSource: "Decimal(sign: .plus, exponent: -3, significand: Decimal(1001 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-7.141)",
            expandedSource: "Decimal(sign: .minus, exponent: -3, significand: Decimal(7141 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0.0)",
            expandedSource: "Decimal(sign: .plus, exponent: -1, significand: Decimal(0 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1_234.5)",
            expandedSource: "Decimal(sign: .plus, exponent: -1, significand: Decimal(12345 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1e5)",
            expandedSource: "Decimal(sign: .plus, exponent: 5, significand: Decimal(1 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.0e5)",
            expandedSource: "Decimal(sign: .plus, exponent: 5, significand: Decimal(1 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23e4)",
            expandedSource: "Decimal(sign: .plus, exponent: 2, significand: Decimal(123 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23e+4)",
            expandedSource: "Decimal(sign: .plus, exponent: 2, significand: Decimal(123 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1.23E-2)",
            expandedSource: "Decimal(sign: .plus, exponent: -4, significand: Decimal(123 as UInt64))",
            macros: testMacros
        )

        // The maximum significand supported by the simple initialiser is 2^64 - 1 or 18,446,744,073,709,551,615.

        assertMacroExpansion(
            "#decimal(0.18446744073709551615)",
            expandedSource: "Decimal(sign: .plus, exponent: -20, significand: Decimal(18446744073709551615 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-1844674407370955161.5)",
            expandedSource: "Decimal(sign: .minus, exponent: -1, significand: Decimal(18446744073709551615 as UInt64))",
            macros: testMacros
        )

        // The minimum significand that requires the full initialiser is 2^64 or 18,446,744,073,709,551,616.

        assertMacroExpansion(
            "#decimal(0.18446744073709551616)",
            expandedSource:
                "Decimal(_exponent: -20, _length: 5, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 1, 0, 0, 0))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-1844674407370955161.6)",
            expandedSource:
                "Decimal(_exponent: -1, _length: 5, _isNegative: 1, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 1, 0, 0, 0))",
            macros: testMacros
        )

        // The maximum significand is 2^128 - 1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.

        assertMacroExpansion(
            "#decimal(0.340282366920938463463374607431768211455)",
            expandedSource:
                "Decimal(_exponent: -39, _length: 8, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-34028236692093846346337460743176821145.5)",
            expandedSource:
                "Decimal(_exponent: -1, _length: 8, _isNegative: 1, _isCompact: 1, _reserved: 0, _mantissa: (65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535))",
            macros: testMacros
        )

        // The maximum exponent is 2^7 - 1 or 127.

        assertMacroExpansion(
            "#decimal(1e127)",
            expandedSource: "Decimal(sign: .plus, exponent: 127, significand: Decimal(1 as UInt64))",
            macros: testMacros
        )

        // The minimum exponent is -2^7 or -128.

        assertMacroExpansion(
            "#decimal(1e-128)",
            expandedSource: "Decimal(sign: .plus, exponent: -128, significand: Decimal(1 as UInt64))",
            macros: testMacros
        )
    }

    func testMacroExpandsGivenDecimalIntegerLiteral() {
        assertMacroExpansion(
            "#decimal(3)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: Decimal(3 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(+5)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: Decimal(5 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(-7)",
            expandedSource: "Decimal(sign: .minus, exponent: 0, significand: Decimal(7 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: Decimal(0 as UInt64))",
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(1_234)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: Decimal(1234 as UInt64))",
            macros: testMacros
        )

        // The maximum significand supported by the simple initialiser is 2^64 - 1 or 18,446,744,073,709,551,615.

        assertMacroExpansion(
            "#decimal(18446744073709551615)",
            expandedSource: "Decimal(sign: .plus, exponent: 0, significand: Decimal(18446744073709551615 as UInt64))",
            macros: testMacros
        )

        // Trailing zeros are ok because they are facilitated by the exponent.

        assertMacroExpansion(
            "#decimal(184467440737095516150000)",
            expandedSource: "Decimal(sign: .plus, exponent: 4, significand: Decimal(18446744073709551615 as UInt64))",
            macros: testMacros
        )

        // The minimum significand that requires the full initialiser is 2^64 or 18,446,744,073,709,551,616.

        assertMacroExpansion(
            "#decimal(18446744073709551616)",
            expandedSource:
                "Decimal(_exponent: 0, _length: 5, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 1, 0, 0, 0))",
            macros: testMacros
        )

        // The maximum significand is 2^128 - 1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.

        assertMacroExpansion(
            "#decimal(340282366920938463463374607431768211455)",
            expandedSource:
                "Decimal(_exponent: 0, _length: 8, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535))",
            macros: testMacros
        )

        // Trailing zeros are ok because they are facilitated by the exponent.

        assertMacroExpansion(
            "#decimal(340282366920938463463374607431768211455000000)",
            expandedSource:
                "Decimal(_exponent: 6, _length: 8, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (65535, 65535, 65535, 65535, 65535, 65535, 65535, 65535))",
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
                DiagnosticSpec(message: "Cannot convert '0xA.Bp2' to 'Decimal'", line: 1, column: 1)
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
                DiagnosticSpec(message: "Cannot convert '0b101' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0o123)",
            expandedSource: "#decimal(0o123)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '0o123' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(0xABC)",
            expandedSource: "#decimal(0xABC)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '0xABC' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenOutOfRangeFloatingPointLiteral() {
        // The maximum significand is 2^128 - 1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.

        assertMacroExpansion(
            "#decimal(0.340282366920938463463374607431768211456)",
            expandedSource: "#decimal(0.340282366920938463463374607431768211456)",
            diagnostics: [
                DiagnosticSpec(
                    message: "Cannot convert '0.340282366920938463463374607431768211456' to 'Decimal'",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )

        assertMacroExpansion(
            "#decimal(34028236692093846346337460743176821145.6)",
            expandedSource: "#decimal(34028236692093846346337460743176821145.6)",
            diagnostics: [
                DiagnosticSpec(
                    message: "Cannot convert '34028236692093846346337460743176821145.6' to 'Decimal'",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )

        // The maximum exponent is 2^7 - 1 or 127.

        assertMacroExpansion(
            "#decimal(1e128)",
            expandedSource: "#decimal(1e128)",
            diagnostics: [
                DiagnosticSpec(
                    message: "Cannot convert '1e128' to 'Decimal'",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )

        // The minimum exponent is -2^7 or -128.

        assertMacroExpansion(
            "#decimal(1e-129)",
            expandedSource: "#decimal(1e-129)",
            diagnostics: [
                DiagnosticSpec(
                    message: "Cannot convert '1e-129' to 'Decimal'",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenOutOfRangeIntegerLiteral() {
        // The maximum significand is 2^128 - 1 or 340,282,366,920,938,463,463,374,607,431,768,211,455.

        assertMacroExpansion(
            "#decimal(340282366920938463463374607431768211456)",
            expandedSource: "#decimal(340282366920938463463374607431768211456)",
            diagnostics: [
                DiagnosticSpec(
                    message: "Cannot convert '340282366920938463463374607431768211456' to 'Decimal'",
                    line: 1,
                    column: 1
                )
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenUnsupportedIntegerLiteral() {
        // The literals in this test could be converted to `Decimal`. We have chosen not to:
        // 1. To avoid complicating the macro implementation.
        // 2. As they can be rewritten trivially in canonical form.

        // Negative zero needs to be rewritten as positive zero.

        assertMacroExpansion(
            "#decimal(-0)",
            expandedSource: "#decimal(-0)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '-0' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        // Leading non-significant zeros need to be removed.

        assertMacroExpansion(
            "#decimal(01)",
            expandedSource: "#decimal(01)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '01' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenUnsupportedFloatingPointLiteral() {
        // The literals in this test could be converted to `Decimal`. We have chosen not to:
        // 1. To avoid complicating the macro implementation.
        // 2. As they can be rewritten trivially in canonical form.

        // Negative zero needs to be rewritten as positive zero.

        assertMacroExpansion(
            "#decimal(-0.0)",
            expandedSource: "#decimal(-0.0)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '-0.0' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        // One trailing non-significant zero is supported, but additional trailing zeros need to be removed.

        assertMacroExpansion(
            "#decimal(1.00)",
            expandedSource: "#decimal(1.00)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '1.00' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        // Leading non-significant zeros need to be removed.

        assertMacroExpansion(
            "#decimal(01.2)",
            expandedSource: "#decimal(01.2)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '01.2' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )

        // Scientific notation must be written in canonical form (in this case `1.2345e4`).

        assertMacroExpansion(
            "#decimal(1234.5e1)",
            expandedSource: "#decimal(1234.5e1)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert '1234.5e1' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

    func testMacroFailsGivenDoubleConstant() {
        assertMacroExpansion(
            "#decimal(Double.nan)",
            expandedSource: "#decimal(Double.nan)",
            diagnostics: [
                DiagnosticSpec(message: "Cannot convert 'Double.nan' to 'Decimal'", line: 1, column: 1)
            ],
            macros: testMacros
        )
    }

}
