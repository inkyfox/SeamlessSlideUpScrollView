//
//  SeamlessSlideUpScrollViewType.swift
//  SeamlessSlideUpScrollView
//
//  Created by indy on 2016. 6. 7..
//  Copyright © 2016년 Gen X Hippies Company. All rights reserved.
//

import Foundation

@objc public protocol SeamlessSlideUpScrollViewType {
    var contentOffset: CGPoint { get }
    var pauseScroll: Bool { get set }
    func resetScrollTranslation()
    func layoutSuperviewIfNeeded()
    func layoutSuperviewIfNeeded(superview: UIView)
}
