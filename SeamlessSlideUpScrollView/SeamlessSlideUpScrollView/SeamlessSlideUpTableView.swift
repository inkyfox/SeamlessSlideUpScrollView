//
//  SeamlessSlideUpTableView.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import UIKit

public class SeamlessSlideUpTableView: UITableView, SeamlessSlideUpScrollViewType {

    private var translationSize: CGSize = CGSizeZero
    private var originalContentOffset: CGPoint = CGPointZero
    private var ignoreContentOffsetChange: Bool = false

    override public var contentOffset: CGPoint {
        get { return super.contentOffset }
        
        set {
            if self.ignoreContentOffsetChange { return }
            self.originalContentOffset = newValue
            if self.pauseScroll {
                super.contentOffset = CGPointZero
            } else {
                super.contentOffset = CGPointMake(newValue.x + self.translationSize.width, newValue.y + self.translationSize.height)
            }
        }
    }
    
    public var pauseScroll: Bool = false {
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
    
    public func resetScrollTranslation() {
        self.translationSize = CGSizeZero
    }

    public func layoutSuperviewIfNeeded() {
        layoutSuperview(nil)
    }

    public func layoutSuperviewIfNeeded(superview: UIView) {
        layoutSuperview(superview)
    }
    
    private func layoutSuperview(superview: UIView?) {
        if let view = superview ?? self.superview {
            self.ignoreContentOffsetChange = true
            view.layoutIfNeeded()
            self.ignoreContentOffsetChange = false
        }
    }
}
