
enum Year: Int, CaseIterable, Decodable {
    case all = 0
    case year2018 = 2018
    case year2019 = 2019
}

// MARK: -

extension Year: CustomStringConvertible {
    var description: String {
        return rawValue == 0 ? "All" : rawValue.description
    }
}
