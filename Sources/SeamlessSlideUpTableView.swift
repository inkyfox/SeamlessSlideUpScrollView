//
//  SeamlessSlideUpTableView.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

open class SeamlessSlideUpTableView: UITableView, SeamlessSlideUpScrollViewType {
    
    var translationSize: CGSize = CGSize.zero
    var ignoreContentOffsetChange: Bool = false

    fileprivate var originalContentOffset: CGPoint = CGPoint.zero

    override open var contentOffset: CGPoint {
        get { return super.contentOffset }
        
        set {
            if self.ignoreContentOffsetChange { return }
            self.originalContentOffset = newValue
            
            let y: CGFloat
            if self.pauseScroll {
                y = 0
                super.contentOffset = CGPoint.zero
            } else {
                y = newValue.y + self.translationSize.height
                super.contentOffset = CGPoint(x: newValue.x + self.translationSize.width, y: y)
            }
            self.contentOffsetYChangedCallback?(y)
        }
        
    }
    
    var contentOffsetYChangedCallback: ((CGFloat) -> Void)? = nil
    
    var pauseScroll: Bool = false {
        didSet {
            if self.pauseScroll != oldValue {
                self.showsVerticalScrollIndicator = !self.pauseScroll
                if !pauseScroll {
                    self.translationSize = CGSize(width: -self.originalContentOffset.x, height: -self.originalContentOffset.y)
                    if self.contentOffset.y > 0 {
                        super.contentOffset = CGPoint.zero
                    }
                }
            }
        }
    }
    
}
