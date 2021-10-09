
enum Continent: String, CaseIterable, Decodable {
    case africa = "Africa"
    case americas = "Americas"
    case asia = "Asia"
    case europe = "Europe"
    case oceania = "Oceania"
}

// MARK: -

extension Continent: CustomStringConvertible {
    
    var description: String { rawValue }
}
