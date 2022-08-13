//
//  ViewController.swift
//  JsonHW
//
//  Created by Даниил Петров on 09.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterAvatar: UIImageView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    private let charactersCount = 826
    private var character: Character?
    
    override func viewWillLayoutSubviews() {
        characterAvatar.layer.cornerRadius = characterAvatar.frame.width / 2
    }
    
    @IBAction func fetchCharacter(_ sender: UIButton) {
        guard
            let url = URL(string: "https://rickandmortyapi.com/api/character/" +
                          "\(Int.random(in: 1...charactersCount))")
        else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            guard let data = data else {
                print(error?.localizedDescription ?? "Empty error description")
                return
            }
            do {
                self.character = try JSONDecoder().decode(
                    Character.self,
                    from: data
                )
                
                DispatchQueue.main.async { [self] in
                    guard let character = character else {
                        return
                    }
                    configure(with: character)
                }
            }
            catch let error {
                print(error.localizedDescription)
                self.failedAlert()
            }
        }.resume()
    }
    
}
extension ViewController {
    
    func configure(with character: Character) {
        characterName.isHidden = false
        characterName.text = character.name
        statusLabel.text = "Status: \(character.status)"
        speciesLabel.text = "Species: \(character.species)"
        typeLabel.text = "Type: \(character.type)"
        
        DispatchQueue.global().async {
            guard let imageUrl = URL(string: character.image) else { return }
            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
            
            DispatchQueue.main.async {
                self.characterAvatar.image = UIImage(data: imageData)
            }
        }
    }
}

extension ViewController {
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Failed",
                message: "You can see error in the Debug area",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}
