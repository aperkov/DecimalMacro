import Foundation

/// A macro that makes it easy to declare `Decimal` values precisely.
///
/// This code:
///
/// ```
/// import DecimalMacro
///
/// let good = #decimal(3.24)
/// let alsoGood = #decimal(1234567890.0987654321)
///
/// print(good)
/// print(alsoGood)
/// ```
///
/// Produces this output:
///
/// ```
/// 3.24
/// 1234567890.0987654321
/// ```
///
/// This contrasts with what you might otherwise try:
///
/// ```
/// let bad = Decimal(3.24)
/// let alsoBad = 3.24 as Decimal
///
/// print(bad)
/// print(alsoBad)
/// ```
///
/// Which produces this output:
///
/// ```
/// 3.240000000000000512
/// 3.240000000000000512
/// ```
///
/// - Parameters:
///   - value: The decimal value.
@freestanding(expression)
public macro decimal(_ value: FloatLiteralType) -> Decimal =
    #externalMacro(module: "DecimalMacroImpl", type: "DecimalMacro")
