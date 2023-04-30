//
//  ChildrenBook.swift
//  handbook-iOS
//
//  Created by Cecilia Chen on 4/28/23.
//

import Foundation

struct Breed: Codable, CustomStringConvertible, Identifiable {
    let id: String
    let name: String
    let temperament: String
    let breedExplaination: String
    let energyLevel: Int
    let isHairless: Bool
    let image: BreedImage?
    
    var description: String {
        return "book with name: \(name) and id \(id) "
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case temperament
        case breedExplaination = "description"
        case energyLevel = "energy_level"
        case isHairless = "hairless"
        case image
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(String.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        temperament = try values.decode(String.self, forKey: .temperament)
        breedExplaination = try values.decode(String.self, forKey: .breedExplaination)
        energyLevel = try values.decode(Int.self, forKey: .energyLevel)
        
        let hairless = try values.decode(Int.self, forKey: .isHairless)
        isHairless = hairless == 1
        image = try values.decodeIfPresent(BreedImage.self, forKey: .image)
    }
    
    init(name: String, id:String, temperament:String, breedExplaination:String, energyLevel: Int, isHairless:Bool, image: BreedImage?) {
        self.name = name
        self.id = id
        self.temperament = temperament
        self.breedExplaination = breedExplaination
        self.energyLevel = energyLevel
        self.image = image
        self.isHairless = isHairless
    }
    
    static func example1() -> Breed {
        return Breed(
            name: "Abyssinian",
            id: "abys",
            temperament: "Active, energy",
            breedExplaination: "easy to take care of",
            energyLevel: 5,
            isHairless: false,
            image: nil)
    }

    static func example2() -> Breed {
        let imageTemp = BreedImage(height: 100, id: "12345", url: "https://picsum.photos/id/237/200/300", width: 200)

        return Breed(
            name: "Cyprus",
            id: "cypr",
            temperament: "Loving, loyal",
            breedExplaination: "easy to take care of",
            energyLevel: 4,
            isHairless: false,
            image: imageTemp)
    }
}
