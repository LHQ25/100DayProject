

enum House: String, Decodable {
    case gryffindor
    case slytherin
    case ravenclaw
    case hufflepuff
    
    var name: String {
        switch self {
        case .gryffindor:
            return "Gryffindor"
        case .slytherin:
            return "Slytherin"
        case .ravenclaw:
            return "Ravenclaw"
        case .hufflepuff:
            return "Hufflepuff"
        }
    }
}
