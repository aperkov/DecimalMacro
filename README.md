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
print(good)

let alsoGood = #decimal(1234567890.0987654321)
print(alsoGood) 
```

Produces the output you probably expect: 

```
3.24
1234567890.0987654321
```

## What problem does this solve?

The most intuitive way to declare a `Decimal` value in Swift probably doesn't behave the way you expect.

This code:

```swift
let bad = Decimal(3.24)
print(bad)
``` 

Produces surprising (arguably incorrect) output:

```
3.240000000000000512
```

Why is this so?

Initialising with `Decimal(3.24)` invokes `init(_ value: Double)`. 

See the problem? The literal you supply is converted to a `Double` and then to `Decimal`. This introduces floating point 
precision problems. Avoiding these problems is probably why you wanted to use `Decimal` in the first place. 

Without the `#decimal` macro you can declare a precise `Decimal` value in various ways:

1. From a string literal - e.g. `Decimal(string: "3.24", locale: Locale.current)!`
2. From a signed 32 bit significand and exponent - e.g. `Decimal(sign: .plus, exponent: -2, significand: 324)`. The 
   `significand` is itself a `Decimal`, so you can use tweak this approach to pass an unsigned 64 bit significand.
3. From an unsigned 128 bit significand and exponent - e.g. 
   `Decimal(_exponent: -2, _length: 1, _isNegative: 0, _isCompact: 1, _reserved: 0, _mantissa: (324, 0, 0, 0, 0, 0, 0, 0))`

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

If your literal contains more than 19 significant digits a different initialiser is needed. 

So this code:

```swift
#decimal(0.18446744073709551616)
``` 

Expands to:

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

It is possible to support these literals. Choosing not to keeps the macro implementation simpler.

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
