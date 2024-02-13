func buildString(_ initial: String = "", builder: (inout String) -> Void) -> String {
    var string = initial
    builder(&string)
    return string
}
