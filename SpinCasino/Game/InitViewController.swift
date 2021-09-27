//
//  InitViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 19.08.2021.
//

import UIKit
import Firebase
import AppTrackingTransparency
import AppsFlyerLib

class InitViewController: BaseVC {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @objc func checkWithChecker() {
        
        Checker.shared.checkEveryting { (url) in
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                if let url = url {
                    print("TUTORIAL: \(url)")
                    self.openHelp(with: url)
                } else {
                    print("NATIVE NATIVE NATIVE")
                    self.openGame()
                }
            }
        }
    }
    
    func openHelp(with url: URL) {
        indicator.stopAnimating()
        
        let helpVC = HelpViewController()
        helpVC.modalPresentationStyle = .fullScreen
        helpVC.url = url
        self.present(helpVC, animated: false, completion: nil)
    }
    

    func openGame() {
        indicator.stopAnimating()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.present(vc, animated: true, completion: nil)
    }
}
