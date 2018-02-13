//
//  DiaryListViewController.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import UIKit

class DiaryListViewController: ViewController {
    @IBOutlet weak var diaryCollectionView: UICollectionView!
    @IBOutlet weak var countLabel: UILabel!
    
    var capsule: [Capsule] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewController()
        
    }
    
    override func setViewController() {
//        setCollectionView(collectionView: diaryCollectionView, cell: DiaryCollectionViewCell.self)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DiaryCollectionViewCell.reuseIdentifier, for: indexPath) as! DiaryCollectionViewCell
        cell.backgroundColor = UIColor().random()
        cell.dateLabel.text = capsule[indexPath.row].date.dateToString()
        cell.contentLabel.text = capsule[indexPath.row].content
        cell.opacityView.alpha =  CGFloat(capsule[indexPath.row].date.timeIntervalSinceNow / 1000000)
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

