//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class DiaryListViewController: ViewController, TableCollectionProtocol {
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    
    var capsule: [String] = ["Sample1", "Sample2", "Sample3", "Sample4", "Sample5"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
    }
    
    override func setViewController() {
        setCollectionView(collectionView: diaryCollectionView, cell: DiaryCollectionViewCell.self)
        if let layout = diaryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        
        countLabel.text =  String( capsule.count)
    }
    
}

extension DiaryListViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return capsule.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier, for: indexPath) as! DiaryCollectionViewCell
        cell.backgroundColor = UIColor().random()
        cell.contentLabel.text = capsule[indexPath.row]
        return cell
    }
    
}

extension DiaryListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height/5)
    }
}

extension UIColor {
    func random() -> UIColor {
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1)
    }
}

