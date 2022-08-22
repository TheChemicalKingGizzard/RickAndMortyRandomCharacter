//
//  FavouritesTableVC.swift
//  JsonHW
//
//  Created by Даниил Петров on 18.08.2022.
//

import UIKit

protocol RandomCharacterVCDelegate {
    func add(character: Character)
}

class FavouritesTableVC: UITableViewController {
    
    var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        characters = StorageManager.shared.fetchCharacters()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let randomCharVC = segue.destination as? RandomCharacterVC else { return }
        randomCharVC.delegate = self
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        characters.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath)
        
        let character = characters[indexPath.row]
        var content = cell.defaultContentConfiguration()
        
        content.text = character.name
        content.secondaryText = character.species
        
        
//        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
//        content.imageProperties.cornerRadius = 50
//
        return cell
    }
    @IBAction func show(_ sender: Any) {
        print(characters)
        print(characters.count)
    }
}
extension FavouritesTableVC: RandomCharacterVCDelegate {
    
    func add(character: Character) {
        characters.append(character)
        tableView.reloadData()
        print("reload")
    }
}
