//
//  NumPadCollectionViewCell.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/4/21.
//

import UIKit

class NumPadCollectionViewCell: UICollectionViewCell {
    public static let identifier = "numPad"
    
    @IBOutlet weak var numpadLabel: UILabel!
    @IBOutlet weak var circleView: UIView!

    override func layoutSubviews() {
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
}
