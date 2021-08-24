//
//  PasscodeDigitCollectionViewCell.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/4/21.
//

import UIKit

class PasscodeDigitCollectionViewCell: UICollectionViewCell {
    
    /// The cells identifier
    public static let identifier = "passcodeDigit"
    
    let imageView = UIImageView()
    
    public var hasValue: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    fileprivate func setupViews() {
        imageView.frame = contentView.frame
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .label
        contentView.addSubview(imageView)
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    override func layoutSubviews() {
        if hasValue {
            imageView.image = UIImage(systemName: "circle.fill")
        } else {
            imageView.image = UIImage(systemName: "circle.dashed")
        }
    }

}
