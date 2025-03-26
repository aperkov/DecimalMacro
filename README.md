# DecimalMacro

A Swift macro that makes it easy to declare `Decimal` values precisely.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faperkov%2FDecimalMacro%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/aperkov/DecimalMacro)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Faperkov%2FDecimalMacro%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/aperkov/DecimalMacro)

## Adding to your project

To use DecimalMacro in a SwiftPM project:

1. Add to the dependencies in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/aperkov/DecimalMacro.git", from: "1.0.0")
],
```

2. Add `DecimalMacro` as a dependency for your target:

```swift
.target(name: "MyTarget", dependencies: [
    .product(name: "DecimalMacro", package: "DecimalMacro")
])
```

3. Add `import DecimalMacro` in your source code.

## Sample usage

This code:

```swift
let good = #decimal(3.24)
let alsoGood = #decimal(1234567890.0987654321)

print(good)
print(alsoGood) 
```

Produces the output you probably expect: 

```
3.24
1234567890.0987654321
```

## What problem does this solve?

The most intuitive ways to declare a `Decimal` value in Swift probably don't behave the way you expect.

This code:

```swift
let bad = Decimal(3.24)
let alsoBad = 3.24 as Decimal

print(bad)
print(alsoBad)
``` 

Produces surprising (arguably incorrect) output:

```
3.240000000000000512
3.240000000000000512
```

Why is this so?

The examples above invoke `init(_ value: Double)` and `init(floatLiteral value: Double)` respectively. 

See the problem? 

In both cases the literal you supply is converted to a `Double` and then to a `Decimal`. This introduces floating point 
precision problems. This is annoying because avoiding these problems is probably why you wanted to use `Decimal` in the 
first place. 

Without the `#decimal` macro you can declare a precise `Decimal` value in various ways:

```swift
// Option #1 - parse a string.
let a = Decimal(string: "3.24", locale: Locale.current)!

// Option #2 - provide a "small" significand and exponent. 
// The significand can be up to 2^64 - 1, or about 20 decimal digits.  
let b = Decimal(sign: .plus, exponent: -2, significand: 324)
let c = Decimal(sign: .plus, exponent: -2, significand: Decimal(324 as UInt64))

// Option #3 - provide a large significand (aka mantissa) and exponent. 
// The significand can be up to 2^128 - 1, or about 39 decimal digits. 
let d = Decimal(
    _exponent: -2, 
    _length: 1, 
    _isNegative: 0, 
    _isCompact: 1, 
    _reserved: 0, 
    _mantissa: (324, 0, 0, 0, 0, 0, 0, 0)
)
```

None of these are great options.

If you use option 1 you lose compile time type checking, risk locale related bugs, and incur the cost of parsing a 
string at runtime.

If you use option 2 your code becomes hard to read and write, and the number of significant digits supported is 
reduced from about 39 to about 20.

If you use option 3 your code becomes _really_ hard to read and write. 

## What does the macro expand to? 

This code:

```swift
#decimal(3.24)
```

Expands to:

```swift
Decimal(sign: .plus, exponent: -2, significand: Decimal(324 as UInt64))
```

And this code:

```swift
#decimal(0.18446744073709551616)
``` 

Contains more significant digits than fit into `UInt64`, so it expands to:

```swift
Decimal(_exponent: -20, _length: 5, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 1, 0, 0, 0))
```

This way:

1. Your code is easy to read and write. 
2. You retain compile time type checking.
3. You can use the full range of the `Decimal` type (up to 39 significant digits).
4. Expanded code is as readable as possible.
5. Your code avoids locale related bugs.
6. Your code avoids the cost of parsing strings at runtime.

## Limitations

The `#decimal` macro accepts decimal floating point literal arguments. 

A compilation error will occur if `#decimal` is passed literals containing:
 
1. Binary, octal, or hexidecimal values.
2. Negative zero. 
3. Leading zeros. E.g. `03`.
4. More that one trailing zero. E.g. `3.00`
5. Non-canonical scientific notation.  E.g. `1234.5e1` (instead of `1.2345e4`).

Choosing not to support these literals keeps the macro implementation simpler.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
