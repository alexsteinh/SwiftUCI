extension Collection {
    subscript(safeIndex index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
