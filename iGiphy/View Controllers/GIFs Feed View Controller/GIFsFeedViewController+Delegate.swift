//
//  GIFsFeedViewController+Delegate.swift
//  iGiphy
//
//  Created by Mohamed Fawzy on 28/08/2021.
//

import UIKit

extension GIFsFeedViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard viewModel.moreGIFsToLoad, reachedBottomOf(scrollView: scrollView) else {
            return
        }
        viewModel.loadMoreGIFs()
    }
    
    private func reachedBottomOf(scrollView: UIScrollView) -> Bool {
        let loadedItemsCount = viewModel.gifsCount
        guard let lastDisplayedRow = tableView.indexPathsForVisibleRows?.last?.row else {
            return false
        }
        let displayedItemsCount = lastDisplayedRow + 1
        return Double(displayedItemsCount) / Double(loadedItemsCount) >= loadMoreThreshold
    }
    
}
