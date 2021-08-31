//
//  FavouriteGIFsViewControllerLayout.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 30/08/2021.
//

import UIKit

extension FavouriteGIFsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2 - 14
        let height = width * 0.6 + 40
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
         UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
    
}
