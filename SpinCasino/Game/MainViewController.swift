//
//  ViewController.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 16.08.2021.
//

import UIKit

class MainViewController: BaseVC {
    
    private var level: Int = Int(Level.shared.level) {
        didSet {
            Level.shared.level = level
            chipsLevelButton.setTitle("\(level)", for: .normal)
        }
    }
    
    @IBOutlet weak var horisontalShit: PlainHorizontalProgressBar!
    
    @IBOutlet weak var chipsLevelButton: UIButton! {
        didSet {
            chipsLevelButton.setTitle("\(Level.shared.level)", for: .normal)
        }
    }
    
    private var imageCollectionViewCellID = "ImageCollectionViewCell"
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named:"insidebg")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    var slotsElementsPack2: [UIImage] = [UIImage(named: "Element1")!,
                                         UIImage(named: "Element2")!,
                                         UIImage(named: "Element3")!,
                                         UIImage(named: "Element4")!,
                                         UIImage(named: "Element5")!,
                                         UIImage(named: "Element6")!
    ]
    
    var slotsElementsPack1: [UIImage] = [UIImage(named: "Element7")!,
                                         UIImage(named: "Element8")!,
                                         UIImage(named: "Element9")!,
                                         UIImage(named: "Element10")!,
                                         UIImage(named: "Element11")!,
                                         UIImage(named: "Element12")!
    ]
    
    var imagesArray = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chipsLevelButton.translatesAutoresizingMaskIntoConstraints = false
//        if Level.shared.level > 1 {
//            imagesArray[1] = UIImage(named: "5")
//        }
//
//        self.collectionView.backgroundView = imageView
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        level = Level.shared.level
//        if Level.shared.level > 1 {
//            imagesArray[1] = UIImage(named: "5")
//        }
//
        if UserDefaultsManager.LevelChoose == 0 {
            for i in 1...4 {
                imagesArray.append(UIImage(named: "\(i)")!)
            }
        }else if UserDefaultsManager.LevelChoose == 2 {
            imagesArray.removeAll()
            imagesArray.append(UIImage(named: "\(1)")!)
            imagesArray.append(UIImage(named: "\(2)")!)
            imagesArray.append(UIImage(named: "\(5)")!)
            imagesArray.append(UIImage(named: "\(4)")!)
        }else if UserDefaultsManager.LevelChoose == 3 {
            imagesArray.removeAll()
            imagesArray.append(UIImage(named: "\(1)")!)
            imagesArray.append(UIImage(named: "\(2)")!)
            imagesArray.append(UIImage(named: "\(5)")!)
            imagesArray.append(UIImage(named: "\(6)")!)
        }
        DispatchQueue.main.async {
            self.horisontalShit.setNeedsDisplay()
        }
    }
 
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//
//    }
    
    @IBAction func buyCoins(_ sender: UIButton) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "StoreViewController") as! StoreViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    let imageViewBackTomorrow = UIImage(named: "backTomorrow")
    let imageViewLuckyYou = UIImage(named: "luckyYou")
    
    @IBAction func getBonusTapped(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "PopUpViewController") as! PopUpViewController
        if Level.shared.getBonus == false {
            vc.imageView = imageViewLuckyYou!
            Level.shared.coinsPool += 500
            Level.shared.getBonus = true
        }else {
            vc.imageView = imageViewBackTomorrow!
        }
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
   
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionViewCellID, for: indexPath) as! ImageCollectionViewCell
        cell.slotsImage.image = imagesArray[indexPath.row]        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK:- TODO Send an array of elements to vc
        if indexPath.item == 0 {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SlotViewController") as! SlotViewController
            controller.slotsElements = slotsElementsPack2
            self.navigationController?.pushViewController(controller, animated: true)
        } else if indexPath.item == 1 {
//            if Level.shared.level >= 2 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SlotViewController") as! SlotViewController
                controller.slotsElements = slotsElementsPack1
                self.navigationController?.pushViewController(controller, animated: true)
//            }
        } else if indexPath.item == 2 {
            if Level.shared.coinsPool >= 5000 {
                UserDefaultsManager.LevelChoose = 2
                Level.shared.coinsPool = Level.shared.coinsPool - 5000
            }
            if UserDefaultsManager.LevelChoose == 2 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SlotViewController") as! SlotViewController
                controller.slotsElements = slotsElementsPack2
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else if indexPath.item == 3 {
            if Level.shared.coinsPool >= 8000 {
                UserDefaultsManager.LevelChoose = 2
                Level.shared.coinsPool = Level.shared.coinsPool - 8000
            }
            if UserDefaultsManager.LevelChoose == 2 {
                let controller = self.storyboard?.instantiateViewController(withIdentifier: "SlotViewController") as! SlotViewController
                controller.slotsElements = slotsElementsPack1
                self.navigationController?.pushViewController(controller, animated: true)
            }
        } else {
            return
        }
    }
}



//    func showAlertWithText(header:String = "Warning", message:String) {
//        let alert = UIAlertController(
//            title: header,
//            message: message,
//            preferredStyle: UIAlertControllerStyle.alert
//        )
//
//        alert.addAction(
//            UIAlertAction(
//                title: "Ok",
//                style: UIAlertActionStyle.default,
//                handler: nil
//            )
//        )
//
//        self.present(alert,
//                     animated: true,
//                     completion: nil
//        )
//    }
