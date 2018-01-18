//
//  TableCollectionProtocol.swift
//  Diary
//
//  Created by 이광용 on 2018. 1. 17..
//  Copyright © 2018년 이광용. All rights reserved.
//

import Foundation
import UIKit

protocol TableCollectionProtocol {
}

extension TableCollectionProtocol {
    func getNextViewController(viewController: UIViewController.Type) -> UIViewController{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        return storyBoard.instantiateViewController(withIdentifier: viewController.reuseIdentifier)
    }
}
extension TableCollectionProtocol where Self: UITableViewDataSource & UITableViewDelegate {
    func setTableView(tableView: UITableView, tableViewCell: UITableViewCell.Type){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: tableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: tableViewCell.reuseIdentifier)
    }
    
    func getReusableCell(tableView: UITableView, cell: UITableViewCell.Type, indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: cell.reuseIdentifier, for: indexPath)
    }
}

extension TableCollectionProtocol where Self: UICollectionViewDataSource & UICollectionViewDelegate {
    func setCollectionView(collectionView: UICollectionView, cell: UICollectionViewCell.Type){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: cell.reuseIdentifier, bundle: nil) , forCellWithReuseIdentifier: cell.reuseIdentifier)
    }
}
