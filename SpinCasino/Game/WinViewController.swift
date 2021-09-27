//
//  WinViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 23.08.2021.
//

import UIKit

class WinViewController: BaseVC {
    
    @IBOutlet weak var NumberOfWonChips: UILabel!
    
    var wonChipsLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NumberOfWonChips.text = wonChipsLabel.text
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
