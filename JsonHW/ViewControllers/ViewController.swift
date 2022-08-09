//
//  ViewController.swift
//  JsonHW
//
//  Created by Даниил Петров on 09.08.2022.
//

import UIKit

class ViewController: UIViewController {
    
    private let currentCharacterscount = 826
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var characterAvatar: UIImageView!
    
    override func viewWillLayoutSubviews() {
        characterAvatar.layer.cornerRadius = characterAvatar.frame.width / 2
        }
    
    @IBAction func fetchCharacter(_ sender: UIButton) {
        
        guard
            let url = URL(string: "https://rickandmortyapi.com/api/character/" +
                            "\(Int.random(in: 1...currentCharacterscount))")
        else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data else {
                print(error?.localizedDescription ?? "Empty error description")
                return
            }
            
            do {
                let character = try JSONDecoder().decode(Person.self, from: data)
                print(character)
                
                guard
                    let avatarUrl = URL(string: character.image ) else {
                    return
                }
                URLSession.shared.dataTask(with: avatarUrl) {
                    [weak self] data, _, _ in
                    guard let avatarData = data else { return }
                    
                DispatchQueue.main.async {
                    self?.nameLabel.isHidden = false
                    self?.nameLabel.text = character.name
                    self?.characterAvatar.image = UIImage(data: avatarData)
                }
                }.resume()
                
            } catch let error {
                self?.failedAlert()
                print(error)
            }
            
        }.resume()
    }
    
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
