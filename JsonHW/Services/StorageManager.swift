//
//  StorageManager.swift
//  JsonHW
//
//  Created by Даниил Петров on 22.08.2022.
//

/*
 class StorageManager {
     static let shared = StorageManager()
     
     private let defaults = UserDefaults.standard
     private let contactKey = "contactsKey"
     
     private init() {}
     
     func save(contact: Contact) {
         var contacts = fetchContacts()
         contacts.append(contact)
         guard let data = try? JSONEncoder().encode(contacts) else { return }
         defaults.set(data, forKey: contactKey)
     }
     
     func fetchContacts() -> [Contact] {
         guard let data = defaults.data(forKey: contactKey) else { return [] }
         guard let contacts = try? JSONDecoder().decode([Contact].self, from: data) else { return [] }
         return contacts
     }
     
     func deleteContact(at index: Int) {
         var contacts = fetchContacts()
         contacts.remove(at: index)
         guard let data = try? JSONEncoder().encode(contacts) else { return }
         defaults.set(data, forKey: contactKey)
     }
 }
 */
import Foundation

class StorageManager {
    static let shared = StorageManager()
    
    private let defaults = UserDefaults.standard
    private let characterKey = "characterKey"
    
    private init() {}
    
    func addToFav(character: Character) {
        var characters = fetchCharacters()
        characters.append(character)
        guard let data = try? JSONEncoder().encode(characters) else { return }
        defaults.set(data, forKey: characterKey)
    }
    
    func fetchCharacters() -> [Character] {
        guard let data = defaults.data(forKey: characterKey) else { return [] }
        guard let characters = try? JSONDecoder().decode([Character].self, from: data) else { return [] }
        return characters
    }
    
    func deleteCharacter(at index: Int) {
        var characters = fetchCharacters()
        characters.remove(at: index)
        guard let data = try? JSONEncoder().encode(characters) else { return }
        defaults.set(data, forKey: characterKey)
    }
}
