# SeamlessSlideUpScrollView

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)

###CocoaPods
~~~
platform :ios, '9.0'
use_frameworks!

pod 'SeamlessSlideUpScrollView'
~~~

###Requirements
* iOS 8.0
* Xcode 7.3.1
* Swift 2.2

###Screen Shots
Slide Up | Seamless Edge Dragg & Scroll | Slide Down after Scroll
--- | --- | ---
![screen_slideup] | ![screen_edge] | ![screen_slidedown]

###Usage
```swift
import UIKit
import SeamlessSlideUpScrollView

class ViewController: UIViewController {

    @IBOutlet weak var slideUpView: SeamlessSlideUpView!
    @IBOutlet var tableView: SeamlessSlideUpTableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If the slide-up view is SeamlessSlideUpTableView
        self.slideUpView.tableView = tableView
        
        // If the slide-up view is SeamlessSlideUpScrollView
        //self.slideUpView.scrollView = scrollView 
        
        self.slideUpView.delegate = self
    }
    
    @IBAction func showSlideUpView(sender: AnyObject) {
        self.slideUpView.show()
    }
}

extension ViewController: SeamlessSlideUpViewDelegate {
    func slideUpViewWillAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
    
    func slideUpViewDidAppear(slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
    
    func slideUpViewWillDisappear(slideUpView: SeamlessSlideUpView) {
    }
    
    func slideUpViewDidDisappear(slideUpView: SeamlessSlideUpView) {
    }
    
    func slideUpViewDidDrag(slideUpView: SeamlessSlideUpView, height: CGFloat) {
    }
}
```

* `SeamlessSlideUpView` must be added and cover on top of the all views.
* `SeamlessSlideUpTableView` need not be attached to any superview. It'll be automatically added to `SeamlessSlideUpView`.


###License
SeamlessSlideUpScrollView is released under the MIT license. See LICENSE for details.

[screen_slideup]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshot0.gif
[screen_edge]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshot1.gif
[screen_slidedown]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshot2.gif
