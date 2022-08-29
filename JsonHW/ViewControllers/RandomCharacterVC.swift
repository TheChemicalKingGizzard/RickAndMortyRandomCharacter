//
//  ViewController.swift
//  JsonHW
//
//  Created by Даниил Петров on 09.08.2022.
//

import UIKit

class RandomCharacterVC: UIViewController{
    
    @IBOutlet var characterName: UILabel!
    @IBOutlet var characterAvatar: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var addToFavButton: UIButton!
    
    
    private var character: Character?
    private var jsonInfo: RickAndMorty?
    private var spinnerView = UIActivityIndicatorView()
    var delegate: RandomCharacterViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchInfo(from: Link.rickAndMortyApi.rawValue)
        addToFavButton.setImage(UIImage.init(systemName: "heart.fill"), for: .normal)
        
    }
    
    override func viewWillLayoutSubviews() {
        characterAvatar.layer.cornerRadius = characterAvatar.frame.width / 2
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let favouritesViewController = segue.destination as? FavouritesTableVC else { return }
//
//        favouritesViewController.character = character
//    }
    
    @IBAction func fetchCharacter(_ sender: UIButton) {
        fetchChar()
        print("000 \(character)")
    }
    
    @IBAction func addToFavourite(_ sender: UIButton) {
        
        print("001 \(character!.id)")
        guard let character = character else { return }
        TransferManager.shared.transferedCharacter = character
        
//        print ("002 \(character.id)")
//        StorageManager.shared.addToFav(character: character)
//        print("003 \(character.id)")
//        print(delegate)
//        delegate.add(character: character)
//        print("004 \(character.id)")
//        dismiss(animated: true)
        save()
        
    }
}

extension RandomCharacterVC {
    
    private func fetchInfo(from url: String?) {
        NetworkManager.shared.fetch(RickAndMorty.self, from: url) { [weak self] result in
            switch result {
            case .success(let info):
                self?.jsonInfo = info
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchChar() {
        guard let jsonInfo = jsonInfo else { return }
        guard let url = URL(string: "https://rickandmortyapi.com/api/character/" + "\(Int.random(in: 1...jsonInfo.info.count))") else { return }
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
                    descriptionLabel.text = character?.description
                    characterName.text = character?.name
                    fetchImage()
                    characterName.isHidden = false
                    descriptionLabel.isHidden = false
                }
            }
            catch let error {
                print(error.localizedDescription)
            }
        }.resume()
        print("010 \(character)")
    }
    
    private func fetchImage() {
        NetworkManager.shared.fetchImage(from: character?.image) { result in
            switch result {
            case .success(let imageData):
                self.characterAvatar.image = UIImage(data: imageData)
                TransferManager.shared.transferedAvatar = UIImage(data: imageData)
                self.spinnerView.stopAnimating()
            case .failure(let error):
                print(error)
            }
        }
        print("020 \(character)")
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView = UIActivityIndicatorView(style: .large)
        spinnerView.color = .black
        spinnerView.startAnimating()
        spinnerView.center = characterAvatar.center
        spinnerView.hidesWhenStopped = true
        
        view.addSubview(spinnerView)
    }
    
    private func save() {
        guard let character = character else { return }

        
        
        StorageManager.shared.addToFav(character: character)
        

        dismiss(animated: true)
    }
}


