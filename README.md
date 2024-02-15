# SwiftUCI

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Falexsteinh%2FSwiftUCI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/alexsteinh/SwiftUCI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Falexsteinh%2FSwiftUCI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/alexsteinh/SwiftUCI)

A swifty way to parse and write Universal Chess Interface (UCI) commands.  
Available from Swift 5.9.

## Features

### Parse UCI commands from strings
```swift
let idCommand = Command(string: "id author alexsteinh")
idCommand == Command.id(.author("alexsteinh"))) // true

let infoCommand = Command(string: "info depth 34 seldepth 40 multipv 1 score cp 30 lowerbound")
infoCommand == Command.info([.depth(34), .seldepth(40), .multipv(1), .score([.cp(30), .lowerbound])]) // true

let normalizedCommand = Command(string: "\tid  name   \t\t\tImaginery\tChess Engine   ")
normalizedCommand == Command.id(.name("Imaginery Chess Engine") // true

let invalidCommand = Command(string: "bogus")
invalidCommand == nil // true
```

### Convert parsed UCI commands back to a string
```swift
let command = Command.id(.author("alexsteinh")))
print(command) // prints "id author alexsteinh"
```
