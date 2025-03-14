import DecimalMacroImpl
import SwiftSyntax
import XCTest

final class DecimalMacroErrorTests: XCTestCase {

    func testDescription() {
        XCTAssertEqual(
            DecimalMacroError.noArguments.description,
            "No arguments received")

        XCTAssertEqual(
            DecimalMacroError.unsupportedArgumentType(StringLiteralExprSyntax.self).description,
            "Unsupported argument type: StringLiteralExprSyntax")
    }

}
