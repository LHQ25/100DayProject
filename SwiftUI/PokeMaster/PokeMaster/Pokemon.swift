//
//  Pokemon.swift
//  PokeMaster
//
//  Created by 9527 on 2022/9/30.
//

import Foundation

struct Pokemon: Codable {
    
    struct Abilities: Codable {
        
        struct Ability: Codable {
            var name: String?
            var url: String?
        }
        
        var ability: Ability?
        var is_hidden: Bool?
        var slot: Int?
    }
    
    struct Form: Codable {
        var name: String?
        var url: String?
    }
    
    struct Game_Indices: Codable {
        struct Version: Codable {
            var name: String?
            var url: String?
        }
        
        var game_index: Int?
        var version: Version?
    }
    
    struct Held_item: Codable {
        struct Item: Codable {
            var name: String?
            var url: String?
        }
        
        struct Version_Detail: Codable {
            
            struct Version: Codable {
                var name: String?
                var url: String?
            }
            
            var rarity: Int?
            var version: Version?
        }
        
        var item: Item?
        var version_details: [Version_Detail]?
    }
    
    struct Moves: Codable {
        
        struct Version_Group_Details: Codable {
            
            var level_learned_at: Int?
            var move_learn_method: Info?
            var version_group: Info?
        }
        
        var move: Info?
        var version_group_details: [Version_Group_Details]?
    }
    
    struct Sprites: Codable {
        
        struct Other: Codable {
            
            struct Dream_World: Codable {
                var front_default: String?
                var front_female: String?
            }
            
            struct Home: Codable {
                var front_default: String?
                var front_female: String?
                var front_shiny: String?
                var front_shiny_female: String?
            }
            
            struct Artwork: Codable {
                var front_default: String?
            }
            
            var dream_world: Dream_World?
            var home: Home?
            var artwork: Artwork?
        }
        
        struct Versions: Codable {
            
        }
        
        var back_default: String?
        var back_female: String?
        var back_shiny: String?
        var back_shiny_female: String?
        var front_default: String?
        var front_female: String?
        var front_shiny: String?
        var front_shiny_female: String?
        var other: Other?
        var versions: Versions?
    }
    
    struct Stats: Codable {
        var base_stat: Int?
        var effort: Int?
        var stat: Info?
    }
    
    struct Types: Codable {
        var slot: Int?
        var type: Info?
    }
    
    var abilities: [Abilities]?
    var base_experience: Int?
    var forms: [Form]?
    var game_indices: [Game_Indices]?
    var height: Int?
    var held_items: [Held_item]?
    var id: Int?
    var is_default: Bool?
    var location_area_encounters: String?
    var moves: [Moves]?
    var name: String?
    var order: Int?
//    var past_types: []
    var species: Info?
    var sprites: Sprites?
    var stats: [Stats]?
    var types: [Types]?
    var weight: Int?
}


struct Info: Codable {
    
    var name: String?
    var url: String?
}
