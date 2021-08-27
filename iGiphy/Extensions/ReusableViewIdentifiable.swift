//
//  ReusableViewIdentifier.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 26/08/2021.
//

import UIKit

protocol ReusableViewIdentifiable: AnyObject {
    static var identifier: String { get }
}

extension ReusableViewIdentifiable where Self: UIView {
    
    static var identifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableViewIdentifiable { }

extension UITableView {
    
    func registerCellFromNib(named name: String) {
        register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
    }
    
}
