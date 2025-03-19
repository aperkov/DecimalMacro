# DecimalMacro

A Swift macro that makes it easy to declare `Decimal` values precisely.

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

Without the macro you can initialise a precise `Decimal` value in Swift:

1. From a string literal - e.g. `Decimal(string: "3.24")!`
2. From an exponent and significand - e.g. `Decimal(sign: .plus, exponent: -2, significand: 324)`

If you use option 1 you lose compile time type checking, and incur the cost of parsing a string at runtime.

If you use option 2 your code becomes hard to read and write.

## What does the macro expand to? 

This code:

```swift
#decimal(3.24)
```

Takes the floating point literal you supply and expands to:

```swift
Decimal(sign: .plus, exponent: -2, significand: 324)
```

This way:
 
1. You retain compile time type checking.
2. Your code is easy to read and write.
3. The expanded code doesn't incur the cost of parsing a string at runtime. 

## Limitations

The `#decimal` macro accepts decimal floating point literal arguments. 

A compilation error will occur if `#decimal` is passed binary, octal, or hexidecimal literals.  

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
