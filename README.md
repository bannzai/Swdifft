# Swdifft
**Swdifft** is string diff library of longest common subsequence.

## Usage
Using diff function, **Swdifft** marked diff between left and right.

```swift
let result = diff("ABCDEFGHIJ", "ABCDEFG")
print(result.lhs) // ABCDEFG`HIJ`
print(result.rhs) // ABCDEFG
```

If it reversed.
```swift
let result = diff("ABCDEFG", "ABCDEFGHIJ")
print(result.lhs) // ABCDEFG
print(result.rhs) // ABCDEFG*HIJ*
```

And it can be print diff.

```swift
printDiff("ABCDEFGHIJ", "ABCDEFG") 
```

Result.
```
ABCDEFG`HIJ`
ABCDEFG
```

**Swdifft** marked symbol's, when string matches the difference.
The mark can customize from default setting to use these global variables. 

```swift
beginLHSMark = "%" // Default is `
endLHSMark = "%" // Default is `
beginRHSMark = "&" // Default is *
endRHSMark = "&" // Default is *
```

# LICENSE
[Swdifft](https://github.com/bannzai/Swdifft/) is released under the MIT license. See [LICENSE](https://github.com/bannzai/Swdifft/blob/master/LICENSE.txt) for details.
