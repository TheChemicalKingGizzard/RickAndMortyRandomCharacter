//
//  Character.swift
//  JsonHW
//
//  Created by Даниил Петров on 09.08.2022.
//

import Foundation

struct RickAndMorty: Decodable {

    let info: Info
    let results: [Character]

}
struct Info: Decodable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}

struct Character: Decodable {

    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let location: Location
    let url: String

    var description: String {
        """
    Status: \(status)
    Species: \(species)
    Gender: \(gender)
    Location: \(location.name)
    """
    }

}

struct Location: Decodable {
    let name: String
    
}

enum Link: String {
    case rickAndMortyApi = "https://rickandmortyapi.com/api/character"
}
