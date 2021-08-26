//
//  GIFsFeedViewController+SearchBarDelegate.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit

extension GIFsFeedViewController: UISearchBarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return .topAttached
    }
    
}
