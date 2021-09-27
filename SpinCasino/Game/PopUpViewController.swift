//
//  PopUpViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 19.08.2021.
//

import UIKit

class PopUpViewController: BaseVC {

    @IBOutlet weak var bonusImage: UIImageView!
        
    var imageView: UIImage = {
        let image = UIImage()
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        bonusImage.image = imageView
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
