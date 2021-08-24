//
//  ColorCollectionViewCell.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/7/21.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override func setNeedsLayout() {
        colorView.makeCircular()
    }
    
    override func layoutSubviews() {
        colorView.makeCircular()
    }
}
