////
////  FloorViewCell.swift
////  Firebase_demo
////
////  Created by Hoang Dinh Huy on 10/24/19.
////  Copyright © 2019 Hoang Dinh Huy. All rights reserved.
////
//
//import UIKit
//
//class FloorViewCell: UICollectionViewCell {
//    
//    @IBOutlet weak var floorCollectionView: UICollectionView!
//    
//    let tableCellID = "tableCellID"
//    var tables = [TableModel]()
//    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//        
//        tables = TableModel.fetchTable()
//        floorCollectionView.reloadData()
//        
//        floorCollectionView.dataSource = self
//        floorCollectionView.delegate = self
//        
//        floorCollectionView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellWithReuseIdentifier: tableCellID)
//    }
//}
//
//extension FloorViewCell: UICollectionViewDataSource {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return tables.count
//       }
//       
//       func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//           let cell = floorCollectionView.dequeueReusableCell(withReuseIdentifier: tableCellID, for: indexPath) as! TableViewCell
//        cell.table = tables[indexPath.item]
//           return cell
//       }
//}
//
//extension FloorViewCell: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: frame.width/2 - 30, height: 80)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        App.shared.rootNagivationController.pushViewController(UIStoryboard.OrderViewController, animated: true)
//    }
//}
//
//extension FloorViewCell: UICollectionViewDelegate {
//    
//}
