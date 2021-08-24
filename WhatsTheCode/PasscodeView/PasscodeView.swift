//
//  PasscodeView.swift
//  WhatsTheCode
//
//  Created by Ryan Sady on 2/4/21.
//

import UIKit

protocol PasscodeViewDelegate {
    func shouldDisable(disable: Bool)
    func digitLentghDidChange(value: Int)
    func didSetKeypadColor(color: UIColor)
}

class PasscodeView: UIView {
    
    var delegate: PasscodeViewDelegate?
    var collectionView: UICollectionView!
    var passcode = [Int]()
    var enteredPasscode = [Int]()
    
    public var digitCount: Int = UserDefaults.standard.integer(forKey: "passcodeLength") {
        didSet {
            layoutSubviews()
            generatePasscode()
        }
    }
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        generatePasscode()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        setupCollectionView()
        generatePasscode()
    }
    
    override func layoutSubviews() {
        let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        let layout = PasscodeDigitFlowLayout(cellsPerRow: digitCount, minimumInteritemSpacing: 0, minimumLineSpacing: 0, sectionInset: insets)
        collectionView.collectionViewLayout = layout
    }
    
    //MARK: - Private Methods
    fileprivate func setupCollectionView() {
        let insets = UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
        let layout = PasscodeDigitFlowLayout(cellsPerRow: digitCount, minimumInteritemSpacing: 0, minimumLineSpacing: 0, sectionInset: insets)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.register(PasscodeDigitCollectionViewCell.self, forCellWithReuseIdentifier: PasscodeDigitCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.backgroundColor = .clear
        
        addSubview(collectionView)
        collectionView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        if digitCount == 0 {
            digitCount = 4
            UserDefaults.standard.setValue(4, forKey: "passcodeLength")
        }
    }
    
    fileprivate func generatePasscode() {
        passcode.removeAll()
        for _ in 1...digitCount {
            passcode.append(Int.random(in: (0...9)))
        }
        print("Passcode: ", passcode)
    }
    
    fileprivate func challengePasscode() {
        if enteredPasscode.elementsEqual(passcode) {
            //User entered passcode matches

        } else {
            delegate?.shouldDisable(disable: true)
            enteredPasscode.removeAll()
            guard let visibleCells = collectionView.visibleCells as? [PasscodeDigitCollectionViewCell] else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.collectionView.shake()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                for cell in visibleCells {
                    cell.hasValue = false
                    self.collectionView.reloadData()
                    self.delegate?.shouldDisable(disable: false)
                }
            }
            
        }
    }
    
    //MARK: - Public Methods
    
    public func didTapDelete() {
        guard !enteredPasscode.isEmpty else { print("Empty Passcode"); return }
        let currentIndex = enteredPasscode.count - 1
        enteredPasscode.remove(at: currentIndex)
        guard let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PasscodeDigitCollectionViewCell else { return }
        cell.hasValue = false
        cell.layoutSubviews()
        
    }
    public func didAddValue(value: Int) {
        enteredPasscode.append(value)
        let currentIndex = enteredPasscode.count - 1
        if let cell = collectionView.cellForItem(at: IndexPath(item: currentIndex, section: 0)) as? PasscodeDigitCollectionViewCell {
            cell.hasValue.toggle()
            cell.layoutSubviews()
        }
        
        if enteredPasscode.count == passcode.count {
            challengePasscode()
        }
        
    }
    
    
    
}


//MARK: - CollectionView Delegates
extension PasscodeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return digitCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PasscodeDigitCollectionViewCell.identifier, for: indexPath) as? PasscodeDigitCollectionViewCell else {
            fatalError()
        }
        
        return cell
    }
}
