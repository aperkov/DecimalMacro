import DecimalMacroImpl
import SwiftSyntax
import XCTest

final class DecimalMacroErrorTests: XCTestCase {

    func testDescription() {
        XCTAssertEqual(DecimalMacroError.noArguments.description, "No arguments received")

        XCTAssertEqual(DecimalMacroError.unsupportedArgument("foo").description, "Cannot parse 'foo' as a 'Decimal'")
    }

}
