//
//  FavouriteListViewController.swift
//  JsonHW
//
//  Created by Даниил Петров on 24.08.2022.
//

import UIKit

protocol RandomCharacterViewControllerDelegate {
    func add(character: Character)
}

class FavouriteListViewController: UIViewController {
    
    private var characters: [Character] = []
    var character: Character?

    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        characters = StorageManager.shared.fetchCharacters()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let newCharacter = TransferManager.shared.transferedCharacter else { return }

        character = newCharacter
        TransferManager.shared.transferedCharacter = nil
        characters.append(newCharacter)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let randomCharVC = tabBarController?.viewControllers?.first as? RandomCharacterVC else { return }
        randomCharVC.delegate = self
    }

    @IBAction func show(_ sender: Any) {
        tableView.reloadData()
    }
}

extension FavouriteListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return characters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "Character", for: indexPath) as! CharacterCell
        let character = characters[indexPath.row]

        cell.nameLabel?.text = character.name
        cell.positionLabel?.text = character.species

        NetworkManager.shared.fetchImage(from: character.image) { result in
            switch result {
            case .success(let imageData):
                cell.avatarImageView?.image = UIImage(data: imageData)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        return cell
    }
}

extension FavouriteListViewController: RandomCharacterViewControllerDelegate {
    func add(character: Character) {
        characters.append(character)
        tableView.reloadData()
    }
}

class CharacterCell: UITableViewCell {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
}
