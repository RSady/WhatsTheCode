//
//  SettingsViewController.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/7/21.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    var passcodeDelegate: PasscodeViewDelegate?
    var previousIndexPath: IndexPath?
    let colors: [ColorPreset] = [ColorPreset(name: "Red", color: .systemRed),
                                 ColorPreset(name: "Blue", color: .systemBlue),
                                 ColorPreset(name: "Green", color: .systemGreen),
                                 ColorPreset(name: "Yellow", color: .systemYellow),
                                 ColorPreset(name: "Purple", color: .systemPurple),
                                 ColorPreset(name: "Pink", color: .systemPink) ,
                                 ColorPreset(name: "Background", color: .secondarySystemBackground)]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        setPasscodeSegmentControl()
    }
    
    @IBAction func passcodeLengthChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: // 4 Digits
            passcodeDelegate?.digitLentghDidChange(value: 4)
            UserDefaults.standard.setValue(4, forKey: "passcodeLength")
        case 1: // 6 Digits
            passcodeDelegate?.digitLentghDidChange(value: 6)
            UserDefaults.standard.setValue(6, forKey: "passcodeLength")
        case 2: // 8 Digits
            passcodeDelegate?.digitLentghDidChange(value: 8)
            UserDefaults.standard.setValue(8, forKey: "passcodeLength")
        default: break
        }
    }
    
    
}

extension SettingsViewController {
    fileprivate func setupView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    fileprivate func setPasscodeSegmentControl() {
        let passcodeLength = UserDefaults.standard.integer(forKey: "passcodeLength")
        switch passcodeLength {
        case 4: segmentedControl.selectedSegmentIndex = 0
        case 6: segmentedControl.selectedSegmentIndex = 1
        case 8: segmentedControl.selectedSegmentIndex = 2
        default: break
        }
    }
}

extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as? ColorCollectionViewCell else { fatalError() }
        cell.colorView.backgroundColor = colors[indexPath.item].color
        if UserDefaults.standard.colorForKey(key: "numPadColor") == colors[indexPath.item].color {
            previousIndexPath = indexPath
            cell.colorView.addStroke()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let prevIndexPath = previousIndexPath, let prevCell = collectionView.cellForItem(at: prevIndexPath) as? ColorCollectionViewCell {
            prevCell.colorView.removeStroke()
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? ColorCollectionViewCell else { return }
        previousIndexPath = indexPath
        cell.colorView.addStroke()
        passcodeDelegate?.didSetKeypadColor(color: colors[indexPath.item].color)
        UserDefaults.standard.setColor(color: colors[indexPath.item].color, forKey: "numPadColor")
    }
}

extension SettingsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
}

