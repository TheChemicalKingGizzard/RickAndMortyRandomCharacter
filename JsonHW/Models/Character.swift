//
//  Character.swift
//  JsonHW
//
//  Created by Даниил Петров on 09.08.2022.
//

import Foundation

struct Character: Decodable {
    
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let image: String
    
}

