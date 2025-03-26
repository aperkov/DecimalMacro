# Minutiae

## `Decimal` significant digits

The `Decimal` type stores its significant digits as an unsigned 128 bit value (8 \* `UInt16` values). So the largest 
supported significand is about 38.5 decimal digits. You can compute this with `log10(2^128 - 1)`.

The "simple" `Decimal` initialiser can accept its significant digits as an unsigned 64 bit value (an `UInt64`). So the 
largest significand you can supply is about 19.3 decimal digits. You can compute this with `log10(2^64 - 1)`. 

## `Decimal` parsing Locale considerations

It's easy to introduce subtle bugs if you rely on the `Decimal` initialisers that parse strings.  

For example this code:

```
let australianLocale = Locale(identifier: "en_AU")
let spanishLocale = Locale(identifier: "es_ES")

print(australianLocale.decimalSeparator!)
print(spanishLocale.decimalSeparator!)
```

Produces:

```
.
,
```

Which means that this code:

```swift
let valueInAustralia = Decimal(string: "3.24", locale: australianLocale)!
let valueInSpain = Decimal(string: "3.24", locale: spanishLocale)! // Expects "3,24"

print(valueInAustralia)
print(valueInSpain)
```

Produces:

```
3.24
3
```

Ouch! 

This happens because `Decimal` parsing stops when it encounters unexpected characters. This can lead to nasty bugs if 
you aren't careful.

## `Decimal` and negative zero

`Decimal` support for negative zero is a bit patchy.

The following code:

```swift
let a = Decimal(string: "-0.0")!
let b = Decimal(string: "-0")!
let c = Decimal(sign: .minus, exponent: -1, significand: 0)
let d = Decimal(sign: .minus, exponent: 0, significand: 0)

print(a)
print(b)
print(c)
print(d)
```

Produces:

```
0
0
0
0
```

`Decimal` _does_ support negative zero, but it's easy to confuse with `NaN`. The following code:

```swift
let e = Decimal(_exponent: -1, _length: 1, _isNegative: 1, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 0, 0, 0, 0))
let f = Decimal(_exponent: 0, _length: 1, _isNegative: 1, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 0, 0, 0, 0))
let g = Decimal(_exponent: 0, _length: 0, _isNegative: 1, _isCompact: 1, _reserved: 0, _mantissa: (0, 0, 0, 0, 0, 0, 0, 0))

print(e)
print(f)
print(g)
```

Produces:

```
-0.0
-0
NaN
```
