//
//  ImageViewController.swift
//  TableViewImplementaion2
//
//  Created by Paolo Cifuentes on 11/19/21.
//

import UIKit

protocol ImageDelegate {
    func updateInformation(isFavorite: Bool)
}

class ImageViewController: UIViewController {

    @IBOutlet private weak var imageName: UILabel!
    @IBOutlet private weak var roverImage: UIImageView!
    @IBOutlet private weak var favoriteButton: UIButton!
    @IBAction func buttonClick(_ sender: UIButton) {
        favorite()
        changeButton()
        self.delegate?.updateInformation(isFavorite: isFavorite)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let rover = rover else { return }
        isFavorite = rover.favorite
        downloadImage()
        favoriteButton.tintColor = .red
        changeButton()
        imageName.text = rover.earthDate
    }
    var rover: Rover?
    var delegate: ImageDelegate?
    var isFavorite = false
    

    func downloadImage() {
        DispatchQueue.main.async {
            guard let url = URL(string: self.rover?.imgSrc ?? "") else  { return }
            if let data = try? Data(contentsOf: url) {
                self.roverImage.image = UIImage(data: data)
            }
        }
        
    }
    
    func favorite() {
        isFavorite = !isFavorite
    }
    func changeButton() {
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
