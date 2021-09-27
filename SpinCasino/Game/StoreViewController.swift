//
//  StoreViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 20.08.2021.
//

import UIKit

class StoreViewController: BaseVC {
    
    enum Product: String, CaseIterable {
        case buy100Coins = "com.endoffapp.spincasino.buy100coins"
        case buy500Coins = "com.endoffapp.spincasino.buy500coins"
        case buy1000Coins = "com.endoffapp.spincasino.buy1000coins"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func backToMainMenu(_ sender: UIButton) {
        self.navigationController!.popViewController(animated: true)
    }
    
    @IBAction func buy100Coins(_ sender: UIButton) {
        IAPManager.shared.purchase(product: .buy100Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    @IBAction func buy500Coins(_ sender: UIButton) {
        IAPManager.shared.purchase(product: .buy500Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    @IBAction func buy1000Coins(_ sender: Any) {
        IAPManager.shared.purchase(product: .buy1000Coins, completion: { [weak self] count in
            DispatchQueue.main.async {
                self?.addCoins(count: count)
            }
        })
    }
    
    private func addCoins(count: Int) {
        let currentCount = Level.shared.coinsPool
        let newCount = currentCount + count
        Level.shared.coinsPool = newCount
    }
}
