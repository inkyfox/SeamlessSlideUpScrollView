//
//  SeamlessSlideUpScrollView.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 8..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

public class SeamlessSlideUpScrollView: UIScrollView, SeamlessSlideUpScrollViewType {
    
    var translationSize: CGSize = CGSizeZero
    var ignoreContentOffsetChange: Bool = false
    
    private var originalContentOffset: CGPoint = CGPointZero

    override public var contentOffset: CGPoint {
        get { return super.contentOffset }
        
        set {
            if self.ignoreContentOffsetChange { return }
            self.originalContentOffset = newValue
            
            let y: CGFloat
            if self.pauseScroll {
                y = 0
                super.contentOffset = CGPointZero
            } else {
                y = newValue.y + self.translationSize.height
                super.contentOffset = CGPointMake(newValue.x + self.translationSize.width, y)
            }
            self.contentOffsetYChangedCallback?(y)
        }
        
    }
    
    var contentOffsetYChangedCallback: (CGFloat -> Void)? = nil
    
    var pauseScroll: Bool = false {
        didSet {
            if self.pauseScroll != oldValue {
                self.showsVerticalScrollIndicator = !self.pauseScroll
                if !pauseScroll {
                    self.translationSize = CGSizeMake(-self.originalContentOffset.x, -self.originalContentOffset.y)
                    if self.contentOffset.y > 0 {
                        super.contentOffset = CGPointZero
                    }
                }
            }
        }
    }
    
}
