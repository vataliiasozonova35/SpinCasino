//
//  imageCollectionViewCell.swift
//  SlotDemo
//
//  Created by Vsevolod Shelaiev on 16.08.2021.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var slotsImage: UIImageView!
}

extension UIView {
    func fillSuperview(insets: UIEdgeInsets = .zero) {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
          topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
          leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
          bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom),
          trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
      }
}
