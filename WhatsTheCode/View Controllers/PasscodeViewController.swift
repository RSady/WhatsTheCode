//
//  PasscodeViewController.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/4/21.
//

import UIKit

class PasscodeViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var passcodeView: PasscodeView!
    
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
    }
    
    @IBAction func didTapDelete(_ sender: UIButton) {
        passcodeView.didTapDelete()
    }
    
    @IBAction func didTapSettings(_ sender: UIButton) {
        presentPopover()
    }
    
    
}

//MARK: - Helpers
extension PasscodeViewController {
    func setupView() {
        let insets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        collectionView.collectionViewLayout = PasscodeDigitFlowLayout(cellsPerRow: 3, minimumInteritemSpacing: 4, minimumLineSpacing: 4, sectionInset: insets)
        collectionView.delegate = self
        collectionView.dataSource = self
        passcodeView.delegate = self
    }
    
    func presentPopover() {
        let popOverContent = storyboard?.instantiateViewController(withIdentifier: "settingsViewController") as? SettingsViewController
        let nav = UINavigationController(rootViewController: popOverContent!)
        nav.modalPresentationStyle = .popover
        let popover = nav.popoverPresentationController
        nav.isNavigationBarHidden = true
        popover?.delegate = self
        popover?.sourceView = view
        popOverContent?.passcodeDelegate = self
        popOverContent?.preferredContentSize = CGSize(width: view.frame.width / 1.25, height: view.frame.height / 2)
        popover?.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        popover?.permittedArrowDirections = .init(rawValue: 0)
        
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - CollectionView Delegates
extension PasscodeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NumPadCollectionViewCell.identifier, for: indexPath) as? NumPadCollectionViewCell else {
            fatalError()
        }
        cell.numpadLabel.text = "\(numbers[indexPath.item])"
        cell.circleView.backgroundColor = UserDefaults.standard.colorForKey(key: "numPadColor") ?? .secondarySystemBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        passcodeView.didAddValue(value: numbers[indexPath.item])

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let totalCellWidth = Int(collectionView.layer.frame.size.width) / 3 * collectionView.numberOfItems(inSection: 0)
        let totalSpacingWidth = (collectionView.numberOfItems(inSection: 0) - 1)
        let leftInset = (collectionView.layer.frame.size.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        print(rightInset)
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

extension PasscodeViewController: PasscodeViewDelegate {
    func shouldDisable(disable: Bool) {
        collectionView.isUserInteractionEnabled = !disable
    }
    
    func digitLentghDidChange(value: Int) {
        passcodeView.digitCount = value
    }
    
    func didSetKeypadColor(color: UIColor) {
        guard let cells = collectionView.visibleCells as? [NumPadCollectionViewCell] else { return }
        for cell in cells {
            cell.circleView.backgroundColor = color
        }
    }
}

extension PasscodeViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        .none
    }
}
