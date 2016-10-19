# SeamlessSlideUpScrollView
![Swift](https://img.shields.io/badge/Swift-3.0-orange.svg)
![Swift](https://img.shields.io/badge/Swift-2.3-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/SeamlessSlideUpScrollView.svg?style=flat)](http://cocoapods.org/pods/SeamlessSlideUpScrollView)
[![License](https://img.shields.io/cocoapods/l/SeamlessSlideUpScrollView.svg?style=flat)](http://cocoapods.org/pods/SeamlessSlideUpScrollView)
[![Platform](https://img.shields.io/cocoapods/p/SeamlessSlideUpScrollView.svg?style=flat)](http://cocoapods.org/pods/SeamlessSlideUpScrollView)

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

## Installation

### CocoaPods

#### Swift 3
```Ruby
pod 'SeamlessSlideUpScrollView'
```

#### Swift 2.3
```Ruby
pod 'SeamlessSlideUpScrollView' => '~>1'
```

## License

MIT

[screen_slideup]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshots/screenshot0.gif
[screen_edge]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshots/screenshot1.gif
[screen_slidedown]: https://raw.githubusercontent.com/inkyfox/SeamlessSlideUpScrollView/master/screenshots/screenshot2.gif
