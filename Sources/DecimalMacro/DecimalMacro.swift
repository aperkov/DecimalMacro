import Foundation

/// A macro that makes it easy to declare `Decimal` values precisely.
///
/// For example this code:
///
/// ```
/// let bad = Decimal(3.24)
/// let good = #decimal(3.24)
///
/// print(bad)
/// print(good)
/// ```
///
/// produces this output:
///
/// ```
/// 3.240000000000000512
/// 3.24
/// ```
@freestanding(expression)
public macro decimal(_ value: FloatLiteralType) -> Decimal =
    #externalMacro(module: "DecimalMacroImpl", type: "DecimalMacro")
