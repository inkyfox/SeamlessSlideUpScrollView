//
//  SeamlessSlideUpScrollViewType.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

protocol SeamlessSlideUpScrollViewType: class {
    var contentOffset: CGPoint { get }
    var contentOffsetYChangedCallback: ((CGFloat) -> Void)? { get set }
    var pauseScroll: Bool { get set }
    
    var translationSize: CGSize { get set }
    var ignoreContentOffsetChange: Bool { get set }
    
    func resetScrollTranslation()
    func layoutSuperviewIfNeeded() 
}

extension SeamlessSlideUpScrollViewType where Self: UIScrollView {
    func resetScrollTranslation() {
        self.translationSize = CGSize.zero
    }
    
    func layoutSuperviewIfNeeded() {
        guard let superview = self.superview else { return }
        layoutSuperviewIfNeeded(superview)
    }
    
    func layoutSuperviewIfNeeded(_ superview: UIView) {
        self.ignoreContentOffsetChange = true
        superview.layoutIfNeeded()
        self.ignoreContentOffsetChange = false
    }
}
