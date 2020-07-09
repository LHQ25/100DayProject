
import Foundation

//Decodable:  Codable是Encodable和Decodable协议总和的别名，既能编码也能解码

//Codable让我们可以通过Struct和Class不要一行多余代码来解析JSON和Plist数据
struct Country: Decodable {
    let name: String
    let continent: Continent
    let region: String
    let population: Int
    let year: Year
    
    enum CodingKeys: String, CodingKey {
        case name = "country"
        case continent, region, population, year
    }
}

// MARK: -

extension Country {
    static func countries() -> [Continent: [Country]] {
        guard
            let url = Bundle.main.url(forResource: "population", withExtension: "json"),
            let data = try? Data(contentsOf: url)
            else {
                return [:]
        }
        
        do {
            let countries = try JSONDecoder().decode([Country].self, from: data)
            var countriesByContient: [Continent: [Country]] = [:]
            
            Continent.allCases.forEach { (continent) in
                countriesByContient[continent] = countries.filter {
                    $0.continent == continent
                }
            }
            return countriesByContient
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    }
    
    var formattedPopulation: String? {
        return NSNumber(value: self.population).formatted()
    }
}
